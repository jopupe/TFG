import spade
import asyncio



async def main():
    """
    Main function to run the agent and manage its behaviours.
    """
    # Create an agent instance (replace 'YourAgentClass' with your actual agent class)
    agent = Agent("your_agent@localhost", "your_password", ag_name="YourAgentName")

    # Start the agent
    await agent.start()

    # Manage behaviours
    while True:
        try:
            await asyncio.sleep(1)  # Keep the main loop running
        except KeyboardInterrupt:
            print("Experiment interrupted by user")
            break

    # Stop the agent
    agent.stop()

class Agent(spade.agent.Agent):
    class Behaviour1(spade.behaviour.CyclicBehaviour):
        async def run(self):
            # Implement the behaviour logic here
            self.contador1 = getattr(self, 'contador1', 1)  # Use getattr to initialize contador1
            print("Running agent behaviour1 with priority:", self.priority, " contador1:", self.contador1)
            self.contador1 += 1
    class Behaviour2(spade.behaviour.CyclicBehaviour):
        async def run(self):
            # Implement the behaviour logic here
            self.contador2 = getattr(self, 'contador2', 1)  # Use getattr to initialize contador2
            print("Running agent behaviour2 with priority:", self.priority, " contador2:", self.contador2)
            self.contador2 += 1
    class Behaviour3(spade.behaviour.CyclicBehaviour):
        async def run(self):
            # Implement the behaviour logic here
            self.contador3 = getattr(self, 'contador3', 1)  # Use getattr to initialize contador3
            print("Running agent behaviour3 with priority:", self.priority, " contador3:", self.contador3)
            self.contador3 += 1
    async def setup(self):
        #await Agent.start(self)
        self.contador1 = 1
        self.contador2 = 1
        self.contador3 = 1
        self.add_behaviour(self.Behaviour1(priority=1))
        self.add_behaviour(self.Behaviour2(priority=2))
        self.add_behaviour(self.Behaviour3(priority=3))

if __name__ == "__main__":
    spade.run(main())