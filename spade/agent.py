import asyncio
import logging
import sys
from asyncio import Task
from hashlib import md5
from typing import Coroutine, Optional, Type, Any, List, TypeVar

import aiosasl
import aioxmpp
import aioxmpp.ibr as ibr
from aioxmpp.dispatcher import SimpleMessageDispatcher

from .behaviour import BehaviourType, FSMBehaviour, CyclicBehaviour, OneShotBehaviour
from .container import Container
from .message import Message
from .presence import PresenceManager
from .template import Template
from .trace import TraceStore
from .web import WebApp

logger = logging.getLogger("spade.Agent")

AgentType = TypeVar("AgentType", bound="Agent")


class AuthenticationFailure(Exception):
    """ """

    pass


class Agent(object):
    def __init__(self, jid: str, password: str, priority = 0, ag_name: str = None, verify_security: bool = False):
        """
        Creates an agent

        Args:
          jid (str): The identifier of the agent in the form username@server
          password (str): The password to connect to the server
          verify_security (bool): Wether to verify or not the SSL certificates
        """
        self.jid = aioxmpp.JID.fromstr(jid)
        self.password = password
        self.verify_security = verify_security

        self.behaviours = []
        self._values = {}

        self.conn_coro = None
        self.stream = None
        self.client = None
        self.message_dispatcher = None
        self.presence = None
        self.loop = None

        self.container = Container()
        self.container.register(self)
        self.max_priority = 9999
        self.loop = self.container.loop
        asyncio.set_event_loop(self.loop)

        # Web service
        self.web = WebApp(agent=self)

        self.traces = TraceStore(size=1000)

        self._alive = asyncio.Event()

        self.priority = priority

        self.ag_name = ag_name


    def set_loop(self, loop) -> None:
        self.loop = loop

    def set_container(self, container: Container) -> None:
        """
        Sets the container to which the agent is attached

        Args:
            container (spade.container.Container): the container to be attached to
        """
        self.container = container

    async def start(self, auto_register: bool = True) -> None:
        """
        Starts this agent.

        Args:
            auto_register (bool): register the agent in the server (Default value = True)

        Returns:
            None
        """
        return await self._async_start(auto_register=auto_register)

    async def _async_start(self, auto_register: bool = True) -> None:
        """
        Starts the agent from a coroutine. This fires some actions:

            * if auto_register: register the agent in the server
            * runs the event loop
            * connects the agent to the server
            * runs the registered behaviours

        Args:
          auto_register (bool, optional): register the agent in the server (Default value = True)

        """
        await self._hook_plugin_before_connection()

        if auto_register:
            await self._async_register()
        self.client = aioxmpp.PresenceManagedClient(
            self.jid,
            aioxmpp.make_security_layer(
                self.password, no_verify=not self.verify_security
            ),
            logger=logging.getLogger(self.jid.localpart),
        )

        # obtain an instance of the service
        self.message_dispatcher = self.client.summon(SimpleMessageDispatcher)

        # Presence service
        self.presence = PresenceManager(self)

        await self.loop.create_task(self._async_connect(), self.priority, ag_name = f"{self.jid.localpart}_") #ag_name = f"{self.ag_name}_connect_"
        #await self._async_connect()

        # register a message callback here
        self.message_dispatcher.register_callback(
            aioxmpp.MessageType.CHAT,
            None,
            self._message_received,
        )

        await self._hook_plugin_after_connection()

        await self.setup()
        self._alive.set()
        for behaviour in self.behaviours:
            if not behaviour.is_running:
                behaviour.set_agent(self)
                if issubclass(type(behaviour), FSMBehaviour):
                    for _, state in behaviour.get_states().items():
                        state.set_agent(self)
                behaviour.start()

    async def _hook_plugin_before_connection(self) -> None:
        """
        Overload this method to hook a plugin before connetion is done
        """
        pass

    async def _hook_plugin_after_connection(self) -> None:
        """
        Overload this method to hook a plugin after connetion is done
        """
        pass

    async def _async_connect(self) -> None:  # pragma: no cover
        """connect and authenticate to the XMPP server. Async mode."""
        try:
            self.conn_coro = self.client.connected()
            aenter = type(self.conn_coro).__aenter__(self.conn_coro)
            self.stream = await aenter
            logger.info(f"Agent {str(self.jid)} connected and authenticated.")
        except aiosasl.AuthenticationFailure:
            raise AuthenticationFailure(
                "Could not authenticate the agent. Check user and password or use auto_register=True"
            )

    async def _async_register(self) -> None:  # pragma: no cover
        """Register the agent in the XMPP server from a coroutine."""
        metadata = aioxmpp.make_security_layer(None, no_verify=not self.verify_security)
        query = ibr.Query(self.jid.localpart, self.password)
        _, stream, features = await aioxmpp.node.connect_xmlstream(self.jid, metadata)
        await ibr.register(stream, query)

    async def setup(self) -> None:
        """
        Setup agent before startup.
        This coroutine may be overloaded.
        """
        await asyncio.sleep(0)
    # Metodo para que el usuario pueda sobreescribir el cambio de prioridad de un comportamiento del agente
    async def change_priority(self)-> None:
        """
        Change the priority of the agent.
        This method may be overloaded by the user to change the priority of a behaviour.
        """
        ag_behaviours = self.get_behaviours()
        behaviours_priorities = {behaviour.name: behaviour.priority for behaviour in ag_behaviours}
        print("Comportamientos y prioridades actuales:", behaviours_priorities)
        for behaviour in ag_behaviours:
            print("Prioridad actual de {}: {}".format(behaviour.name, behaviour.priority))
            opcion = input("¿Quieres cambiar la prioridad de {}? (s/n): ".format(behaviour.name)).lower()
            if opcion == 's':
                try:
                    nueva = int(input("Introduce la nueva prioridad: "))
                    behaviour.priority = nueva
                    #behaviours_priorities[behaviour.name] = nueva
                    loop = asyncio.get_event_loop()
                    handle_of_behaviour = behaviour.get_handle()
                    if behaviour.is_handle_of_behaviour(handle_of_behaviour, behaviour):
                        #loop.change_priority(handle_of_behaviour, nueva)
                        task = behaviour.get_task()
                        task.change_task_priority(nueva, handle_of_behaviour)
                        #behaviour.change_task_priority(nueva)
                        #behaviour.reinsert_in_current_iteration(behaviour)
                        #print("Esperando a que la prioridad de {} sea mayor que {}".format(behaviour.name, max_priority))
                    #ag.priority = nueva
                    #behaviour.kill()
                    #ag.remove_behaviour(behaviour)
                    print("Prioridad de {} cambiada a {}".format(behaviour.name, behaviour.priority))
                    
                except ValueError:
                    print("Valor inválido. Prioridad no cambiada.")
        
        #self.agent.max_priority = min(b.priority for b in self.agent.get_behaviours())
    def change_behaviour_priority_forever(self, behaviour: BehaviourType, new_priority: int) -> None:
        """
        Change the priority of a behaviour permanently.

        Args:
            behaviour (Type[CyclicBehaviour]): the behaviour to change priority
            new_priority (int): the new priority to set

        """
        
        loop = asyncio.get_event_loop()
        handle_of_behaviour = behaviour.get_handle()
        if isinstance(behaviour, OneShotBehaviour):
            if behaviour._already_executed:
                print("Cannot change priority of an already executed OneShotBehaviour")
                return
        if behaviour.is_handle_of_behaviour(handle_of_behaviour, behaviour):
            #loop.change_priority(handle_of_behaviour, new_priority)
            task = behaviour.get_task()

            task.change_task_priority(new_priority, handle_of_behaviour)

    def change_behaviour_priority_once(self, behaviour: BehaviourType, new_priority: int) -> None:
        """
        Change the priority for one iteration.

        Args:
            behaviour (Type[CyclicBehaviour]): the behaviour to change priority
            new_priority (int): the new priority to set

        """
        loop = asyncio.get_event_loop()
        handle_of_behaviour = behaviour.get_handle()
        if isinstance(behaviour, OneShotBehaviour):
            if behaviour._already_executed:
                print("Cannot change priority of an already executed OneShotBehaviour")
                return
        if behaviour.is_handle_of_behaviour(handle_of_behaviour, behaviour):
            loop.change_priority(handle_of_behaviour, new_priority)

    @property
    def name(self) -> str:
        """
        Returns the name of the agent (the string before the '@')

        Returns:
            str: the name of the agent (the string before the '@')
        """
        return self.jid.localpart

    @property
    def avatar(self) -> str:
        """
        Generates a unique avatar for the agent based on its JID.
        Uses Gravatar service with MonsterID option.

        Returns:
          str: the url of the agent's avatar

        """
        return self.build_avatar_url(self.jid.bare())

    @staticmethod
    def build_avatar_url(jid: str) -> str:
        """
        Static method to build a gravatar url with the agent's JID

        Args:
          jid (aioxmpp.JID): an XMPP identifier

        Returns:
          str: an URL for the gravatar

        """
        digest = md5(str(jid).encode("utf-8")).hexdigest()
        return "http://www.gravatar.com/avatar/{md5}?d=monsterid".format(md5=digest)

    def submit(self, coro: Coroutine, priority = 0, name = "") -> Task:
        """
        Runs a coroutine in the event loop of the agent.
        this call is not blocking.

        Args:
          coro (Coroutine): the coroutine to be run

        Returns:
            asyncio.Task: the Task assigned to the coroutine execution

        """

        #Cambiado
        # Crear la tarea utilizando el contexto
        return self.loop.create_task(coro, priority=priority, ag_name= f"{self.jid.localpart}_{name}")
        #return self.loop.create_task(coro, priority=priority, ag_name=f"{self.ag_name}_{name}")
    def add_behaviour(
        self, behaviour: BehaviourType, template: Optional[Template] = None
    ) -> None:
        """
        Adds and starts a behaviour to the agent.
        If template is not None it is used to match
        new messages and deliver them to the behaviour.

        Args:
          behaviour (Type[spade.behaviour.CyclicBehaviour]): the behaviour to be started
          template (spade.template.Template, optional): the template to match messages with (Default value = None)

        """
        behaviour.set_agent(agent=self)
        if issubclass(type(behaviour), FSMBehaviour):
            for _, state in behaviour.get_states().items():
                state.set_agent(self)
        behaviour.set_template(template)

        if(behaviour.priority == None):
            behaviour.priority = self.priority

        self.behaviours.append(behaviour)
        if self.is_alive():
            behaviour.start()

    def remove_behaviour(self, behaviour: Type[CyclicBehaviour]) -> None:
        """
        Removes a behaviour from the agent.
        The behaviour is first killed.

        Args:
          behaviour (Type[spade.behaviour.CyclicBehaviour]): the behaviour instance to be removed

        """
        if not self.has_behaviour(behaviour):
            raise ValueError("This behaviour is not registered")
        index = self.behaviours.index(behaviour)
        self.behaviours[index].kill()
        self.behaviours.pop(index)

    def has_behaviour(self, behaviour: Type[CyclicBehaviour]) -> bool:
        """
        Checks if a behaviour is added to an agent.

        Args:
          behaviour (Type[spade.behaviour.CyclicBehaviour]): the behaviour instance to check

        Returns:
          bool: a boolean that indicates wether the behaviour is inside the agent.

        """
        return behaviour in self.behaviours

    async def stop(self) -> None:
        """
        Stops this agent.
        """
        return await self._async_stop()

    async def _async_stop(self) -> None:
        """Stops an agent and kills all its behaviours."""
        if self.presence:
            self.presence.set_unavailable()
        for behav in self.behaviours:
            behav.kill()
        if self.web.is_started():
            await self.web.runner.cleanup()

        if self.is_alive():
            # Disconnect from XMPP server
            self.client.stop()
            aexit = self.conn_coro.__aexit__(*sys.exc_info())
            await aexit
            logger.info("Client disconnected.")

        self._alive.clear()

    def is_alive(self) -> bool:
        """
        Checks if the agent is alive.

        Returns:
          bool: wheter the agent is alive or not

        """
        return self._alive.is_set()

    def set(self, name: str, value: Any):
        """
        Stores a knowledge item in the agent knowledge base.

        Args:
          name (str): name of the item
          value (object): value of the item

        """
        self._values[name] = value

    def get(self, name: str) -> Any:
        """
        Recovers a knowledge item from the agent's knowledge base.

        Args:
          name(str): name of the item

        Returns:
          object: the object retrieved or None

        """
        if name in self._values:
            return self._values[name]
        else:
            return None
    

    #Metodo añadido para obtener los comportamientos del agente
    def get_behaviours(self) -> List[BehaviourType]:
        """
        Returns a list of all behaviours registered in the agent.

        Returns:
            list: a list of all behaviours registered in the agent.
        """
        return self.behaviours
    """
    def get_running_behaviours(self) -> List[BehaviourType]:
        """
        #Returns a list of all behaviours registered in the agent that are running.

        #Returns:
        #    list: a list of all behaviours registered in the agent that are running.
    """
        running_behaviours = []
        for behaviour in self.behaviours:
            if behaviour.is_running:
                running_behaviours.append(behaviour)
        return running_behaviours
        
    def get_executable_behaviours(self) -> List[BehaviourType]:
        """
        #Returns a list of all behaviours registered in the agent that are executable in that moment.

        #Returns:
        #    list: a list of all behaviours registered in the agent that are executable in that moment.
    """
        executable_behaviours = []
        for behaviour in self.behaviours:
            if isinstance(behaviour, OneShotBehaviour) and not behaviour._already_executed:
                executable_behaviours.append(behaviour)
        return executable_behaviours
    """
    def _message_received(self, msg: aioxmpp.Message) -> List[Task]:
        """
        Callback run when an XMPP Message is reveived.
        This callback delivers the message to every behaviour
        that is waiting for it. First, the aioxmpp.Message is
        converted to spade.message.Message

        Args:
          msg (aioxmpp.Messagge): the message just received.

        Returns:
            list(asyncio.Future): a list of futures of the append of the message at each matched behaviour.

        """

        msg = Message.from_node(msg)
        return self.dispatch(msg)

    def dispatch(self, msg: Message) -> List[Task]:
        """
        Dispatch the message to every behaviour that is waiting for
        it using their templates match.

        Args:
          msg (spade.message.Message): the message to dispatch.

        Returns:
            list(asyncio.Future): a list of tasks for each message queuing in each matching behavior.

        """
        logger.debug(f"Got message: {msg}")
        tasks = []
        matched = False
        for behaviour in (x for x in self.behaviours if x.match(msg)):
            tasks.append(self.submit(behaviour.enqueue(msg), behaviour.priority, behaviour.name))
            logger.debug(f"Message enqueued to behaviour: {behaviour}")
            self.traces.append(msg, category=str(behaviour))
            matched = True
        if not matched:
            logger.warning(f"No behaviour matched for message: {msg}")
            self.traces.append(msg)
        return tasks
