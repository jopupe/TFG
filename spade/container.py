import asyncio
import logging
import sys
from contextlib import suppress
from typing import Coroutine, Awaitable
sys.path.append('D:/Archivos/Uni/TFM/')
from PriorityAsyncio import events

from singletonify import singleton

from .behaviour import BehaviourType
from .message import Message

logger = logging.getLogger("SPADE")

# check if python is 3.6 or higher
if sys.version_info >= (3, 7) and sys.platform == "win32":
    asyncio.set_event_loop_policy(
        asyncio.WindowsSelectorEventLoopPolicy()
    )  # pragma: no cover


def get_or_create_eventloop():  # pragma: no cover
    if sys.version_info < (3, 10):
        loop = events.get_event_loop()
    else:
        try:
            loop = events.get_running_loop()
        except RuntimeError:
            loop = events.new_event_loop()

    asyncio.set_event_loop(loop)
    return loop


@singleton()
class Container(object):
    """
    The container class allows agents to exchange messages
    without using the XMPP socket if they are in the same
    process.
    The container is a singleton.
    """

    def __init__(self):
        self.__agents = {}
        self.loop = get_or_create_eventloop()
        self.is_running = True

    def reset(self) -> None:
        """Empty the container by unregistering all the agents."""
        self.__init__()

    def register(self, agent) -> None:
        """
        Register a new agent.

        Args:
            agent (spade.agent.Agent): the agent to be registered
        """
        self.__agents[str(agent.jid)] = agent
        agent.set_container(self)
        agent.set_loop(self.loop)

    def unregister(self, jid: str) -> None:
        if str(jid) in self.__agents:
            del self.__agents[str(jid)]

    def has_agent(self, jid: str) -> bool:
        """
        Check if an agent is registered in the container.
        Args:
            jid (str): the jid of the agent to be checked.

        Returns:
            bool: wether the agent is or is not registered.
        """
        return jid in self.__agents

    def get_agent(self, jid: str):
        """
        Returns a registered agent
        Args:
            jid (str): the identifier of the agent

        Returns:
            spade.agent.Agent: the agent you were looking for

        Raises:
            KeyError: if the agent is not found
        """
        return self.__agents[jid]
    #Cambio para que devuelva los agentes como una lista
    def get_agents(self):
        """
        Returns a list of all registered agents.
        
        Returns:
            list: a list of all registered agents.
        """
        return list(self.__agents.values())

    async def send(self, msg: Message, behaviour: BehaviourType) -> None:
        """
        This method sends the message using the container mechanism
        when the receiver is also registered in the container. Otherwise,
        it uses the XMPP send method from the original behaviour.
        Args:
            msg (spade.message.Message): the message to be sent
            behaviour: the behaviour that is sending the message
        """
        to = str(msg.to)
        if to in self.__agents:
            self.__agents[to].dispatch(msg)
        else:
            await behaviour._xmpp_send(msg=msg)

    def run(self, coro: Awaitable) -> None:  # pragma: no cover
        self.loop.run_until_complete(coro)


def run_container(main_func: Coroutine) -> None:  # pragma: no cover
    container = Container()
    try:
        container.run(main_func)
    except KeyboardInterrupt:
        logger.warning("Keyboard interrupt received. Stopping SPADE...")
    except Exception as e:  # pragma: no cover
        logger.error("Exception in the event loop: {}".format(e))

    if sys.version_info >= (3, 7):  # pragma: no cover
        tasks = asyncio.all_tasks(loop=container.loop)  # pragma: no cover
    else:
        tasks = asyncio.Task.all_tasks(loop=container.loop)  # pragma: no cover
    for task in tasks:
        task.cancel()
        with suppress(asyncio.CancelledError):
            container.run(task)

    container.loop.close()
    logger.debug("Loop closed")
