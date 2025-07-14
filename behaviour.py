import asyncio
import collections
import logging
import time
import traceback
import PriorityAsyncio

import heapq
from PriorityAsyncio.events import PrioritizedHandle
from PriorityAsyncio.base_events import PrioritizedEventLoop
from PriorityAsyncio.tasks import PrioritizedTask

from abc import ABCMeta, abstractmethod
from asyncio import CancelledError
from datetime import timedelta, datetime
from threading import Event
from typing import Any, Optional, Dict, TypeVar

from .message import Message
from .template import Template


now = datetime.now

logger = logging.getLogger("spade.behaviour")

BehaviourType = TypeVar("BehaviourType", bound="CyclicBehaviour")


class BehaviourNotFinishedException(Exception):
    """ """

    pass


class NotValidState(Exception):
    """ """

    pass


class NotValidTransition(Exception):
    """ """

    pass


class CyclicBehaviour(object, metaclass=ABCMeta):
    """This behaviour is executed cyclically until it is stopped."""

    def __init__(self, priority = None, name = None):
        self.agent = None
        self.template = None
        self._force_kill = Event()
        self._is_done = None
        self._exit_code = 0
        self.presence = None
        self.web = None
        self.is_running = False
        self.priority = priority  
        self.queue = None
        self.name = name if name else str(self.__class__.__name__)

    def set_agent(self, agent) -> None:
        """
        Links behaviour with its owner agent

        Args:
          agent (spade.agent.Agent): the agent who owns the behaviour

        """
        self.agent = agent
        asyncio.set_event_loop(self.agent.loop)
        self._is_done = asyncio.Event()
        self._is_done.set()
        self.queue = asyncio.Queue()
        self.presence = agent.presence
        self.web = agent.web

    def set_template(self, template: Template) -> None:
        """
        Sets the template that is used to match incoming
        messages with this behaviour.

        Args:
          template (spade.template.Template): the template to match with

        """
        self.template = template

    def match(self, message: Message) -> bool:
        """
        Matches a message with the behaviour's template

        Args:
          message(spade.message.Message): the message to match with

        Returns:
          bool: wheter the messaged matches or not

        """
        if self.template:
            return self.template.match(message)
        return True

    def set(self, name: str, value: Any) -> None:
        """
        Stores a knowledge item in the agent knowledge base.

        Args:
          name (str): name of the item
          value (Any): value of the item

        """
        self.agent.set(name, value)

    def get(self, name: str) -> Any:
        """
        Recovers a knowledge item from the agent's knowledge base.

        Args:
          name (str): name of the item

        Returns:
          Any: the object retrieved or None

        """
        return self.agent.get(name)

    def start(self) -> None:
        """starts behaviour in the event loop"""
        if (self.priority == None):
            self.priority = 0

        self.agent.submit(self._start(), priority=self.priority, name = self.name)
        self.is_running = True

    async def _start(self) -> None:
        """
        Start coroutine. runs on_start coroutine and then
        runs the _step coroutine where the body of the behaviour
        is called.
        """
        await self.agent._alive.wait()
        try:
            await self.on_start()
        except Exception as e:
            logger.error(
                "Exception running on_start in behaviour {}: {}".format(self, e)
            )
            self.kill(exit_code=e)
        await self._step()
        self._is_done.clear()

    def kill(self, exit_code: Optional[Any] = None) -> None:
        """
        Stops the behaviour

        Args:
          exit_code (object, optional): the exit code of the behaviour (Default value = None)

        """
        self._force_kill.set()
        if exit_code is not None:
            self._exit_code = exit_code
        logger.info("Killing behavior {0} with exit code: {1}".format(self, exit_code))

    def is_killed(self) -> bool:
        """
        Checks if the behaviour was killed by means of the kill() method.

        Returns:
          bool: whether the behaviour is killed or not

        """
        return self._force_kill.is_set()

    @property
    def exit_code(self) -> Any:
        """
        Returns the exit_code of the behaviour.
        It only works when the behaviour is done or killed,
        otherwise it raises an exception.

        Returns:
          object: the exit code of the behaviour

        Raises:
            BehaviourNotFinishedException: if the behaviour is not yet finished

        """
        if self._done() or self.is_killed():
            print("Behaviour {} acabado o killed, exit code: {}, priority: {}".format(self, self._exit_code, self.priority))
            return self._exit_code
        else:
            raise BehaviourNotFinishedException

    @exit_code.setter
    def exit_code(self, value: Any) -> None:
        """
        Sets a new exit code to the behaviour.

        Args:
          value (object): the new exit code

        """
        self._exit_code = value

    def _done(self) -> bool:
        """
        Returns True if the behaviour has finished
        else returns False

        Returns:
          bool: whether the behaviour is finished or not

        """
        return False

    def is_done(self) -> bool:
        """
        Check if the behaviour is finished

        Returns:
             bool: whether the behaviour is finished or not
        """
        return not self._is_done.is_set()

    async def join(self, timeout: Optional[float] = None) -> None:
        """
        Wait for the behaviour to complete

        Args:
            timeout (Optional[float]): an optional timeout to wait to join (if None, the join is blocking)

        Returns:
            None

        Raises:
            TimeoutError: if the timeout is reached
        """

        return await self._async_join(timeout=timeout)

    async def _async_join(self, timeout: Optional[float]) -> None:
        """
        Coroutine to wait until a behaviour is finished

        Args:
            timeout (Optional[float]): an optional timeout to wait to join

        Raises:
            TimeoutError: fi the timeout is reached
        """
        t_start = time.time()
        while not self.is_done():
            await asyncio.sleep(0.001)
            t = time.time()
            if timeout is not None and t - t_start > timeout:
                raise TimeoutError

    async def on_start(self) -> None:
        """
        Coroutine called before the behaviour is started.
        """
        pass

    async def on_end(self) -> None:
        """
        Coroutine called after the behaviour is done or killed.
        """
        pass

    @abstractmethod
    async def run(self) -> None:
        """
        Body of the behaviour.
        To be implemented by user.
        """
        raise NotImplementedError  # pragma: no cover

    async def _run(self) -> None:
        """
        Function to be overload by more complex behaviours.
        In other case it just calls run() coroutine.
        """
        await self.run()

    async def _step(self) -> None:
        """
        Main loop of the behaviour.
        checks whether behaviour is done or killed,
        otherwise it calls run() coroutine.
        """
        cancelled = False
        while not self._done() and not self.is_killed():
            try:
                loop = asyncio.get_event_loop()
                print("[{}] Event loop before running behaviour: {}".format(self.name, list(loop._ready)))
                for i, h in enumerate(loop._ready):
                    print("loop._ready antes de hacer el _run:")
                    print(f"  {i}: {h}, priority={getattr(h, 'priority', 'sin prioridad')}")
                if self.priority > self.agent.max_priority:
                    print("Behaviour {} ha intentado ejecutarse con prioridad {} pero la prioridad máxima del agente es {}".format(self, self.priority, self.agent.max_priority))
                #await self.wait_until_high_priority()
                await self._run()
                await self.change_multiple_priorities()
                await asyncio.sleep(0)  # relinquish cpu
            except CancelledError:  # pragma: no cover
                logger.debug("Behaviour {} cancelled".format(self))
                cancelled = True
            except Exception as e:
                logger.error(
                    "Exception running behaviour {behav}: {exc}".format(
                        behav=self, exc=e
                    )
                )
                logger.error(traceback.format_exc())
                self.kill(exit_code=e)
        try:
            if not cancelled:
                await self.on_end()
        except Exception as e:
            logger.error("Exception running on_end in behaviour {}: {}".format(self, e))
            self.kill(exit_code=e)
        self.is_running = False
        self.agent.remove_behaviour(self)
    
    def is_handle_of_behaviour(self, handle, behaviour):
        handle_name = getattr(handle, "ag_name", None)
        behaviour_name = behaviour.name
        agent_name = behaviour.agent.name
        
        return handle_name == f"{agent_name}_{behaviour_name}"

    def reinsert_in_current_iteration(self, behaviour):
        loop = asyncio.get_running_loop()
        # Cancelar el handle actual si es este comportamiento
        for i, h in enumerate(loop._ready):
            print(f"[DEBUG] Handle {i}: {h}, priority={getattr(h, 'priority', '?')}, _behaviour_id={getattr(h, '_behaviour_id', 'None')}")
        current_handle = getattr(loop, "_current_handle", None)
        if current_handle and getattr(current_handle, "_callback", None) == behaviour._step:
            current_handle.cancel()
        new_ready = []
        found_prioritized_task = False

        while loop._ready:
            handle = heapq.heappop(loop._ready)
            if behaviour.is_handle_of_behaviour(handle, behaviour):
                print(f"[DEBUG] Eliminado handle de {behaviour.name}: {handle}")
            if isinstance(handle, PrioritizedHandle) and isinstance(getattr(handle._callback, "__self__", None), PrioritizedTask):
                found_prioritized_task = True
            else:
                new_ready.append(handle)

        loop._ready = new_ready
        heapq.heapify(loop._ready)

        # Volver a insertar con la prioridad nueva
        if found_prioritized_task:
            # Recrea como PrioritizedTask
            print(f"[DEBUG] Reinsertando como PrioritizedTask a {behaviour.name}")
            task = PrioritizedTask(behaviour._step(), loop=loop, priority=behaviour.priority)
            task.ag_name = behaviour.agent.ag_name
            handle = PrioritizedHandle(task._PrioritizedTask__step, (), loop, task.priority, task.ag_name)
            heapq.heappush(loop._ready, handle)
        else:
            # Inserta como callback directo
            print(f"[DEBUG] Reinsertando como callback simple a {behaviour.name}")
            handle = PrioritizedHandle(behaviour._step, (), loop, behaviour.priority, behaviour.agent.ag_name)
            heapq.heappush(loop._ready, handle)

    async def wait_until_high_priority(self) -> None:
        """
        Coroutine to wait until the behaviour's priority is higher than a given value.
        This method is intended to be called from the agent's console.

        Args:
            min_priority (int): the minimum priority to wait for
        """
        while self.priority > self.agent.max_priority:
            await asyncio.sleep(0.1)
            
    def get_handle(self) -> PrioritizedHandle:
        """
        Returns the handle of the behaviour in the event loop.
        This is useful to change the priority of the behaviour.

        Returns:
            PrioritizedHandle: the handle of the behaviour in the event loop
        """
        loop = asyncio.get_event_loop()
        for handle in loop._ready:
            if self.is_handle_of_behaviour(handle, self):
                return handle
        raise ValueError("Behaviour not found in event loop")
    async def change_multiple_priorities(self):
        """
        Allows the user to change the priority of multiple behaviours.
        This method is intended to be called from the agent's console.
        """

        agentes = self.agent.container.get_agents()
        
        for ag in agentes:
            behaviours = ag.get_behaviours()
            for behaviour in behaviours:
                if isinstance(behaviour, OneShotBehaviour):
                    print("Comportamiento {} de {}: esta already executed {}".format(behaviour.name, ag.ag_name, behaviour._already_executed))
        #print("Agentes registrados:{}".format(", ".join([ag.ag_name for ag in agentes])))
        print("Quieres cambiar la prioridad de los comportamientos de algún agente? (s/n)")
        ag_behaviours = self.agent.get_behaviours()
        behaviours_priorities = {behaviour.name: behaviour.priority for behaviour in ag_behaviours}
        self.agent.max_priority = min(behaviours_priorities.values())
        opcion1 = input().lower()
        if opcion1 != 's':
            #await self.wait_until_high_priority(max_priority)
            return
        """
        for ag in agentes:
            ag_behaviours = ag.get_behaviours()
            print(ag.ag_name)
            print("Comportamientos: {}".format(", ".join([b.name for b in ag_behaviours])))
        """
        
        print("Comportamientos y prioridades actuales:", behaviours_priorities)
        for behaviour in ag_behaviours:
            print("Prioridad actual de {}: {}".format(behaviour.name, behaviour.priority))
            opcion = input("¿Quieres cambiar la prioridad de {}? (s/n): ".format(behaviour.name)).lower()
            if opcion == 's':
                try:
                    nueva = int(input("Introduce la nueva prioridad: "))
                    behaviour.priority = nueva
                    behaviours_priorities[behaviour.name] = nueva
                    loop = asyncio.get_event_loop()
                    handle_of_behaviour = behaviour.get_handle()
                    if behaviour.is_handle_of_behaviour(handle_of_behaviour, behaviour):
                        loop.change_priority(handle_of_behaviour, nueva)
                        #behaviour.reinsert_in_current_iteration(behaviour)
                        #print("Esperando a que la prioridad de {} sea mayor que {}".format(behaviour.name, max_priority))
                    #ag.priority = nueva
                    #behaviour.kill()
                    #ag.remove_behaviour(behaviour)
                    print("Prioridad de {} cambiada a {}".format(behaviour.name, behaviour.priority))
                    
                except ValueError:
                    print("Valor inválido. Prioridad no cambiada.")
        
        self.agent.max_priority = min(b.priority for b in self.agent.get_behaviours())
        
        #self.agent.max_priority = min(b.priority for b in all_behaviours)
        #await self.wait_until_high_priority(max_priority)
        """""
        if isinstance(behaviour, PeriodicBehaviour):
            nuevo = behaviour.__class__(period=behaviour.period.total_seconds(), priority=behaviour.priority)
            ag.add_behaviour(nuevo)

        elif isinstance(behaviour, TimeoutBehaviour):
            nuevo = behaviour.__class__(start_at=behaviour._timeout, priority=behaviour.priority)
            ag.add_behaviour(nuevo)

        elif isinstance(behaviour, FSMBehaviour):
            nuevo = behaviour.__class__(priority=behaviour.priority)
            ag.add_behaviour(nuevo)
        
        elif isinstance(behaviour, OneShotBehaviour):
            if not behaviour._already_executed:
                nuevo = behaviour.__class__(priority=behaviour.priority)
                ag.add_behaviour(nuevo)
        
        elif isinstance(behaviour, CyclicBehaviour):
            nuevo = behaviour.__class__(priority=behaviour.priority)
            ag.add_behaviour(nuevo)
        """
    def change_priorities(self):
        """
        Allows the user to change the priority of the behaviour.
        This method is intended to be called from the agent's console.
        """
        """
        loop = asyncio.get_event_loop()
        behaviours = self.agent.get_behaviours()
        for behaviour in behaviours:
            print("Prioridad actual de {}: {}".format(behaviour.name, behaviour.priority))
            opcion = input("¿Quieres cambiar la prioridad de {}? (s/n): ".format(behaviour.name)).lower()
            if opcion == 's':
                try:
                    nueva = int(input("Introduce la nueva prioridad: "))
                    behaviour.priority = nueva
                    #nuevo = behaviour.__class__( priority=100)
                    #asyncio.wait(fs)
                    behaviour.kill()  # Stop the behaviour to apply the new priority
                    self.agent.add_behaviour(behaviour)  # Re-add the behaviour with the new priority
                    #self.agent.remove_behaviour(behaviour)
                    #self.agent.add_behaviour(behaviour)  # Re-add the behaviour with the new priority
                #    handle = next(
                #    (h for h in loop._ready
                #    if hasattr(h, 'callback') and getattr(h.callback, '__self__', None) == behaviour),
                #    None
                #)
                    #loop.update_handle_priority(loop, handle, nueva)
                    #self.agent.set_loop(loop)
                    
                    print("Prioridad de {} cambiada a {}".format(behaviour.name, behaviour.priority))
            
                except ValueError:
                    
                    print("Valor inválido. Prioridad no cambiada.")
        """
    def change_priority(self):
        """
        print("Prioridad actual de {}: {}".format(self.agent.ag_name, self.priority))
        opcion = input("¿Quieres cambiar la prioridad? (s/n): ").lower()
        if opcion == 's':
            try:
                nueva = int(input("Introduce la nueva prioridad: "))
                self.priority = nueva
                self.agent.priority = nueva
                print("Prioridad cambiada a {}".format(self.priority))
                self.kill()  # Stop the behaviour to apply the new priority

                if isinstance(self, PeriodicBehaviour):
                    nuevo = self.__class__(period=self.period.total_seconds(), priority=self.priority)
                    self.agent.add_behaviour(nuevo)

                elif isinstance(self, FSMBehaviour):
                    nuevo = self.__class__(priority=self.priority)
                    # Se recomienda copiar los estados si es necesario
                    self.agent.add_behaviour(nuevo)

                elif isinstance(self, CyclicBehaviour):
                    nuevo = self.__class__(priority=self.priority)
                    self.agent.add_behaviour(nuevo)
            except ValueError:
                print("Valor inválido. Prioridad no cambiada.")
        elif opcion == 'n':
            print("Prioridad no cambiada")
        else:
            print("Entrada no válida. Prioridad no cambiada.")
        """
    async def enqueue(self, message: Message) -> None:
        """
        Enqueues a message in the behaviour's mailbox

        Args:
            message (spade.message.Message): the message to be enqueued
        """
        asyncio.create_task(self.queue.put(message))

    def mailbox_size(self) -> int:
        """
        Checks if there is a message in the mailbox

        Returns:
          int: the number of messages in the mailbox

        """
        return self.queue.qsize()

    async def send(self, msg: Message) -> None:
        """
        Sends a message.

        Args:
            msg (spade.message.Message): the message to be sent.
        """
        if not msg.sender:
            msg.sender = str(self.agent.jid)
            logger.debug(f"Adding agent's jid as sender to message: {msg}")
        await self.agent.container.send(msg, self)
        msg.sent = True
        self.agent.traces.append(msg, category=str(self))

    async def _xmpp_send(self, msg: Message) -> None:
        aioxmpp_msg = msg.prepare()
        await self.agent.client.send(aioxmpp_msg)

    async def receive(self, timeout: Optional[float] = None) -> Optional[Message]:
        """
        Receives a message for this behaviour.
        If timeout is not None it returns the message or "None"
        after timeout is done.

        Args:
            timeout (float, optional): number of seconds until return

        Returns:
            spade.message.Message: a Message or None
        """
        if timeout:
            coro = self.queue.get()
            try:
                msg = await asyncio.wait_for(coro, timeout=timeout)
            except asyncio.TimeoutError:
                msg = None
        else:
            try:
                msg = self.queue.get_nowait()
            except asyncio.QueueEmpty:
                msg = None
        return msg

    def __str__(self) -> str:
        return "{}/{}".format(
            "/".join(base.__name__ for base in self.__class__.__bases__),
            self.__class__.__name__,
        )


class OneShotBehaviour(CyclicBehaviour, metaclass=ABCMeta):
    """This behaviour is only executed once"""

    def __init__(self, priority = None, name = None):
        super().__init__(priority=priority, name=name)
        self._already_executed = False

    def _done(self) -> bool:
        """ """
        if not self._already_executed:
            self._already_executed = True
            return False
        return True


class PeriodicBehaviour(CyclicBehaviour, metaclass=ABCMeta):
    """This behaviour is executed periodically with an interval"""

    def __init__(self, period: float, start_at: Optional[datetime] = None, priority = None, name = None):
        """
        Creates a periodic behaviour.

        Args:
            period (float): interval of the behaviour in seconds
            start_at (datetime.datetime): whether to start the behaviour with an offset
        """
        super().__init__(priority=priority, name=name)
        self._period = None
        self.period = period

        if start_at:
            self._next_activation = start_at
        else:
            self._next_activation = now()

    @property
    def period(self) -> timedelta:
        """Get the period."""
        return self._period

    @period.setter
    def period(self, value: float) -> None:
        """
        Set the period.

        Args:
          value (float): seconds
        """
        if value < 0:
            raise ValueError("Period must be greater or equal than zero.")
        self._period = timedelta(seconds=value)

    async def _run(self) -> None:
        if now() >= self._next_activation:
            logger.debug(f"Periodic behaviour activated: {self}")
            await self.run()
            if self.period <= timedelta(seconds=0):
                self._next_activation = now()
            else:
                while self._next_activation <= now():
                    self._next_activation += self._period
        else:
            seconds = (self._next_activation - now()).total_seconds()
            if seconds > 0:
                logger.debug(
                    f"Periodic behaviour going to sleep for {seconds} seconds: {self}"
                )
                await asyncio.sleep(seconds)


class TimeoutBehaviour(OneShotBehaviour, metaclass=ABCMeta):
    """This behaviour is executed once at after specified datetime"""

    def __init__(self, start_at, priority = None, name = None):
        """
        Creates a timeout behaviour, which is run at start_at

        Args:
            start_at (datetime.datetime): when to start the behaviour
        """
        super().__init__(priority=priority, name=name)

        self._timeout = start_at
        self._timeout_triggered = False

    async def _run(self) -> None:
        if now() >= self._timeout:
            logger.debug(f"Timeout behaviour activated: {self}")
            await self.run()
            self._timeout_triggered = True
        else:
            seconds = (self._timeout - now()).total_seconds()
            if seconds > 0:
                logger.debug(
                    f"Timeout behaviour going to sleep for {seconds} seconds: {self}"
                )
                await asyncio.sleep(seconds)
                await self.run()
                self._timeout_triggered = True

    def _done(self) -> bool:
        """ """
        return self._timeout_triggered


class State(OneShotBehaviour, metaclass=ABCMeta):
    """A state of a FSMBehaviour is a OneShotBehaviour"""

    def __init__(self, priority = None):
        super().__init__(priority=priority)
        self.next_state = None

    def set_next_state(self, state_name: str) -> None:
        """
        Set the state to transition to when this state is finished.
        state_name must be a valid state and the transition must be registered.
        If set_next_state is not called then current state is a final state.

        Args:
          state_name (str): the name of the state to transition to

        """
        self.next_state = state_name


class FSMBehaviour(CyclicBehaviour):
    """A behaviour composed of states (oneshotbehaviours) that may transition from one state to another."""

    def __init__(self, priority = None):
        super().__init__(priority=priority)
        self._states: Dict[str, State] = {}
        self._transitions = collections.defaultdict(list)
        self.current_state: Optional[str] = None
        self.setup()

    def setup(self) -> None:
        """ """
        pass

    def add_state(self, name: str, state: State, initial: bool = False) -> None:
        """Adds a new state to the FSM.

        Args:
          name (str): the name of the state, which is used as its identifier.
          state (spade.behaviour.State): The state class
          initial (bool, optional): wether the state is the initial state or not. (Only one initial state is allowed) (Default value = False)

        """
        if not issubclass(state.__class__, State):
            raise AttributeError("state must be subclass of spade.behaviour.State")
        self._states[name] = state
        if initial:
            self.current_state = name

    def get_state(self, name) -> State:
        return self._states[name]

    def get_states(self) -> Dict[str, State]:
        return self._states

    def add_transition(self, source: str, dest: str) -> None:
        """Adds a transition from one state to another.

        Args:
          source (str): the name of the state from where the transition starts
          dest (str): the name of the state where the transition ends

        """
        self._transitions[source].append(dest)

    def is_valid_transition(self, source: str, dest: str) -> bool:
        """
        Checks if a transitions is registered in the FSM

        Args:
          source (str): the source state name
          dest (str): the destination state name

        Returns:
          bool: wether the transition is valid or not

        """
        if dest not in self._states or source not in self._states:
            raise NotValidState
        elif dest not in self._transitions[source]:
            raise NotValidTransition
        return True

    async def _run(self) -> None:
        behaviour = self._states[self.current_state]
        behaviour.set_agent(self.agent)
        behaviour.receive = self.receive
        logger.info(f"FSM running state {self.current_state}")
        try:
            await behaviour.on_start()
        except Exception as e:
            logger.error("Exception running on_start in state {}: {}".format(self, e))
            self.kill(exit_code=e)
        try:
            await behaviour.run()
        except Exception as e:
            logger.error("Exception running state {}: {}".format(self, e))
            self.kill(exit_code=e)
        try:
            await behaviour.on_end()
        except Exception as e:
            logger.error("Exception running on_start in state {}: {}".format(self, e))
            self.kill(exit_code=e)

        dest = behaviour.next_state
        behaviour._is_done.clear()

        if dest:
            try:
                if self.is_valid_transition(self.current_state, dest):
                    logger.info(f"FSM transiting from {self.current_state} to {dest}.")
                    self.current_state = dest
            except NotValidState as e:
                logger.error(
                    f"FSM could not transitate to state {dest}. That state does not exist."
                )
                self.kill(exit_code=e)
            except NotValidTransition as e:
                logger.error(
                    f"FSM could not transitate to state {dest}. That transition is not registered."
                )
                self.kill(exit_code=e)
        else:
            logger.info(
                "FSM arrived to a final state (no transitions found). Killing FSM."
            )
            self.kill()

    async def run(self) -> None:
        """
        In this kind of behaviour there is no need to overload run.
        The run methods to be overloaded are in the State class.
        """
        raise RuntimeError  # pragma: no cover

    def to_graphviz(self) -> str:
        """
        Converts the FSM behaviour structure to Graphviz syntax

        Returns:
          str: the graph in Graphviz syntax

        """
        graph = "digraph finite_state_machine { rankdir=LR; node [fixedsize=true];"
        for origin, dest in self._transitions.items():
            origin = origin.replace(" ", "_")
            for d in dest:
                d = d.replace(" ", "_")
                graph += "{0} -> {1};".format(origin, d)
        graph += "}"
        return graph
