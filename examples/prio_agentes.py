import asyncio
import spade
import sys
from PriorityAsyncio.base_events import PrioritizedEventLoop
import PriorityAsyncio.tasks 
import PriorityAsyncio.locks

start_event = PriorityAsyncio.locks.PrioritizedEvent(priority=-3)

class Agent(spade.agent.Agent):
    class SendBehaviour(spade.behaviour.PeriodicBehaviour):
        async def run(self):
            loop = asyncio.get_event_loop()
            await start_event.wait()  # Wait for the start signal
            print("{} is sending".format(self.agent.ag_name))
            task = loop.create_task(self.send(spade.message.Message(to="first_agent@localhost", body="Hello", metadata={"performative": "inform"})), priority = self.agent.priority ,ag_name=f"{self.agent.ag_name}_send$")
            await task
            print("{} finished sending".format(self.agent.ag_name))
    async def setup(self):
        print("{} started".format(self.ag_name))
        behaviour = self.SendBehaviour(period=2)
        self.add_behaviour(behaviour)

class Agent1(spade.agent.Agent):
    class ReceiveBehaviour(spade.behaviour.PeriodicBehaviour):
        async def run(self):
            loop = asyncio.get_event_loop()
            await start_event.wait()
            print("{} is receiving".format(self.agent.ag_name))
            task = loop.create_task(self.receive(timeout=100), ag_name=f"{self.agent.ag_name}_receive$")
            await task
            print("{} finished receiving".format(self.agent.ag_name))  
    async def setup(self):
        print("{} started".format(self.ag_name))
        behaviour = self.ReceiveBehaviour(period=2)
        self.add_behaviour(behaviour)




async def main():
    
    first_agent = Agent1("first_agent@localhost", "password", priority = 1, ag_name="FirstAgent")
    second_agent = Agent("second_agent@localhost", "password", priority = 10, ag_name="SecondAgent")
    third_agent = Agent("change_agent@localhost", "password", priority = 5, ag_name="ThirdAgent")
    
    await first_agent.start()
    await second_agent.start()
    await third_agent.start()
    start_event.set()  # Signal to start the agents
    while True:
        try:
            await asyncio.sleep(1)  # Keep the main loop running
        except KeyboardInterrupt:
            print("Experiment interrupted by user")
            break
    
    await first_agent.stop()
    await second_agent.stop()   
    await third_agent.stop()
    print("Experiment finished")


if __name__ == "__main__":
    spade.run(main())