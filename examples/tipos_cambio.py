import asyncio
import spade
import sys
import getpass
from spade.agent import Agent
from datetime import datetime, timedelta
from spade.message import Message
from spade.behaviour import FSMBehaviour, State, TimeoutBehaviour, PeriodicBehaviour
import PriorityAsyncio.locks
STATE_ONE = "STATE_ONE"
STATE_TWO = "STATE_TWO"
STATE_THREE = "STATE_THREE"
start_event = PriorityAsyncio.locks.PrioritizedEvent(priority=-3)

async def main():

    #fsm_agent = spade.FSMAgent("fsm_agent@localhost", "password", priority = 1, ag_name = "FSM Agent")
    #await fsm_agent.start()
    to_agent = TimeoutSenderAgent("to_agent@localhost", "password", priority = 10, ag_name = "timeout Agent")

    to2_agent = TimeoutSenderAgent("to2_agent@localhost", "password", priority = 2, ag_name = "timeout Agent 2")
    
    os_agent = OneShotAgent("os_agent@localhost", "password", priority = 4, ag_name = "OS Agent")
    
    os2_agent = OneShotAgent2("os2_agent@localhost", "password", priority = 1, ag_name = "OS Agent 2")

    
    await os_agent.start()
    await os2_agent.start()
    await to2_agent.start()
    await to_agent.start()
    start_event.set()  # Signal to start the agents
    await spade.wait_until_finished(to_agent)
    await spade.wait_until_finished(to2_agent)
    await spade.wait_until_finished(os_agent)
    await spade.wait_until_finished(os2_agent)
    #await spade.wait_until_finished(fsm_agent)

class TimeoutSenderAgent(spade.agent.Agent):
    class InformBehav(spade.behaviour.TimeoutBehaviour):
        async def run(self):
            await start_event.wait()
            print(f"{self.agent.ag_name} running at {datetime.now()} priority {self.agent.priority}")

    async def setup(self):
        print(f"{TimeoutSenderAgent.__name__} started at {datetime.now()}")
        start_at = datetime.now() + timedelta(seconds=2)
        b = self.InformBehav(start_at=start_at)
        self.add_behaviour(b)

class OneShotAgent(spade.agent.Agent):
    class OneShotBehaviour(spade.behaviour.OneShotBehaviour):
        async def run(self):
            await start_event.wait()
            print(f"Agent {self.agent.ag_name}, comportamiento ejecutado: {self._already_executed}")
            print(f"OneShotBehaviour running {self.agent.ag_name} priority {self.agent.priority} at {datetime.now()}")


    async def setup(self):
        print(f"{OneShotAgent.__name__} started")
        b = self.OneShotBehaviour()
        self.add_behaviour(b)

class OneShotAgent2(spade.agent.Agent):
    class OneShotBehaviour2(spade.behaviour.OneShotBehaviour):
        async def run(self):
            await start_event.wait()
            print(f"Agent {self.agent.ag_name}, comportamiento ejecutado: {self._already_executed}")
            print(f"OneShotBehaviour2 running {self.agent.ag_name} priority {self.agent.priority} at {datetime.now()}")


    async def setup(self):
        print(f"{OneShotAgent2.__name__} started")
        b = self.OneShotBehaviour2()
        self.add_behaviour(b)
        

"""
    class ExampleFSMBehaviour(FSMBehaviour):
        async def on_start(self):
            print(f"FSM starting at initial state {self.current_state}")

        async def on_end(self):
            print(f"FSM finished at state {self.current_state}")
            await self.agent.stop()


    class StateOne(State):
        async def run(self):
            print("I'm at state one (initial state)")
            msg = Message(to=str(self.agent.jid))
            msg.body = "msg_from_state_one_to_state_three"
            await self.send(msg)
            self.set_next_state(STATE_TWO)


    class StateTwo(State):
        async def run(self):
            print("I'm at state two")
            self.set_next_state(STATE_THREE)


    class StateThree(State):
        async def run(self):
            print("I'm at state three (final state)")
            msg = await self.receive(timeout=5)
            print(f"State Three received message {msg.body}")
            # no final state is setted, since this is a final state


    class FSMAgent(Agent):
        async def setup(self):
            fsm = ExampleFSMBehaviour()
            fsm.add_state(name=STATE_ONE, state=StateOne(), initial=True)
            fsm.add_state(name=STATE_TWO, state=StateTwo())
            fsm.add_state(name=STATE_THREE, state=StateThree())
            fsm.add_transition(source=STATE_ONE, dest=STATE_TWO)
            fsm.add_transition(source=STATE_TWO, dest=STATE_THREE)
            self.add_behaviour(fsm)
"""


if __name__ == "__main__":
    spade.run(main())