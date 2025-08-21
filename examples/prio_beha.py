import spade
import asyncio



async def main():
    """
    Main function to run the agent and manage its behaviours.
    """
    # Create an agent instance (replace 'YourAgentClass' with your actual agent class)
    agent = Agent("ag_pr@localhost", "your_password", ag_name="pepito")
    
    # Start the agent
    await agent.start()
    loop = asyncio.get_event_loop()
    """
    for i, h in enumerate(loop._ready):
                    print("loop._ready antes de hacer el _run:")
                    print(f"  {i}: {h}, priority={getattr(h, 'priority', 'sin prioridad')}, ag_name={getattr(h, 'ag_name', 'sin ag_name')}, context={getattr(h, '_context', 'sin context')}, handle={getattr(h, '_handle', 'sin handle')}")
"""
    while True:
        try:
            if agent.contador1 == 5 and agent.contador2 == 5 and agent.contador3 == 5:
                print("Se ha alcanzado el límite de ejecuciones. Se detiene el agente.")
                await agent.stop()
                break
            await asyncio.sleep(1)  # Keep the main loop running
        except KeyboardInterrupt:
            print("Experiment interrupted by user")
            break

    # Stop the agent
    await agent.stop()

class Agent(spade.agent.Agent):
    class B1(spade.behaviour.CyclicBehaviour):
        async def run(self):
            agent = self.agent
            self.contador1 = getattr(self, 'contador1', 1)
            self.contador1 += 1
            print("Running agent behaviour1 with priority", agent.get_beh_priority(self), "contador1:", self.contador1)
            if self.contador1 == 5:
                print(f"{self.name} ha alcanzado el límite de ejecuciones. Se detiene.")
                self.kill()
                
    class B2(spade.behaviour.CyclicBehaviour):
        async def run(self):
            agent = self.agent
            self.contador2 = getattr(self, 'contador2', 1)
            self.contador2 += 1
            print("Running agent behaviour2 with priority", agent.get_beh_priority(self), "contador2:", self.contador2)
            if self.contador2 == 5:
                print(f"{self.name} ha alcanzado el límite de ejecuciones. Se detiene.")
                self.kill()
                
    class B3(spade.behaviour.CyclicBehaviour):
        async def run(self):
            agent = self.agent
            self.contador3 = getattr(self, 'contador3', 1)
            self.contador3 += 1
            print("Running agent behaviour3 with priority", agent.get_beh_priority(self), "contador3:", self.contador3)
            if self.contador3 == 5:
                print(f"{self.name} ha alcanzado el límite de ejecuciones. Se detiene.")
                self.kill()
                
    async def setup(self):
        self.contador1 = 0
        self.contador2 = 0
        self.contador3 = 0
        self.b1 = self.B1(priority=1)
        self.b2 = self.B2(priority=2)
        self.b3 = self.B3(priority=3)
        self.b1.contador1 = 0
        self.b2.contador2 = 0
        self.b3.contador3 = 0
        self.add_behaviour(self.b1)
        self.add_behaviour(self.b3)
        self.add_behaviour(self.b2)

    async def change_priority(self):
        if self.b1.contador1 == 3 and self.get_beh_priority(self.b2) == 2:
            self.change_behaviour_priority_forever(self.b2, 1)
            print(f"Priority of {self.b2.name} changed to 1")
            return
        if self.b2.contador2 == 2 and self.is_executing(self.b2):
            self.b3.aux_prio = self.b3.priority
            self.change_behaviour_priority_once(self.b3, -1)
            print(f"Priority of {self.b3.name} changed to -1 for one execution")
            return
        if self.b3.contador3 == 1 and self.get_beh_priority(self.b2) == 1:
            self.change_behaviour_priority_forever(self.b2, 3)
            print(f"Priority of {self.b2.name} changed to 3")
            return

if __name__ == "__main__":
    spade.run(main())