import spade
import asyncio



async def main():
    """
    Main function to run the agent and manage its behaviours.
    """
    # Create an agent instance (replace 'YourAgentClass' with your actual agent class)
    agent = Agent("agente_prueba@localhost", "your_password", ag_name="agente_prueba")
    
    # Start the agent
    await agent.start()
    loop = asyncio.get_event_loop()
    """
    for i, h in enumerate(loop._ready):
                    print("loop._ready antes de hacer el _run:")
                    print(f"  {i}: {h}, priority={getattr(h, 'priority', 'sin prioridad')}, ag_name={getattr(h, 'ag_name', 'sin ag_name')}, context={getattr(h, '_context', 'sin context')}, handle={getattr(h, '_handle', 'sin handle')}")
"""
    #print("event loop:")
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
    class Behaviour1(spade.behaviour.OneShotBehaviour):
        async def run(self):
            # Implement the behaviour logic here
            #loop = asyncio.get_event_loop()
            ag = self.agent
            ag.contador1 = getattr(ag, 'contador1', 1)  # Use getattr to initialize contador1
            print(f"Running agent {self.agent.name}_{self.name} behaviour1 with priority: {self.priority}, contador1: {ag.contador1}")

            ag.contador1 += 1

    class Behaviour2(spade.behaviour.OneShotBehaviour):
        async def run(self):
            # Implement the behaviour logic here
            #loop = asyncio.get_event_loop()
            ag = self.agent
            ag.contador2 = getattr(ag, 'contador2', 1)  # Use getattr to initialize contador2
            print(f"Running agent {self.agent.name}_{self.name} behaviour2 with priority: {self.priority}, contador2: {ag.contador2}")

            ag.contador2 += 1

    class Behaviour3(spade.behaviour.CyclicBehaviour):
        async def run(self):
            # Implement the behaviour logic here
            #loop = asyncio.get_event_loop()
            ag = self.agent
            ag.contador3 = getattr(ag, 'contador3', 1)  # Use getattr to initialize contador3
            print(f"Running agent {self.agent.name}_{self.name} behaviour3 with priority: {self.priority}, contador3: {ag.contador3}")

            ag.contador3 += 1

    async def setup(self):
        #await Agent.start(self)
        self.contador1 = 1
        self.contador2 = 1
        self.contador3 = 1
        self.b1 = self.Behaviour1(priority=1)
        self.b2 = self.Behaviour2(priority=2)
        self.b3 = self.Behaviour3(priority=3)
        self.add_behaviour(self.b1)
        self.add_behaviour(self.b2)
        self.add_behaviour(self.b3)
    async def change_priority(self):
        print("se ha entrado en el metodo change_priority del agente")
        #print("Self contador1:", self.contador1)
        #if self.contador1 >= 5:
        print("Quieres cambiar la prioridad de Behaviour2?")
        if input("Introduce 's' para cambiar la prioridad de Behaviour2, o cualquier otra tecla para no cambiarla: ").lower() != 's':
            print("No se ha cambiado la prioridad de Behaviour2")
            return
            
        nueva_prioridad = int(input("Introduce la nueva prioridad para Behaviour2: "))
        self.change_behaviour_priority(self.b2, nueva_prioridad)
        #print(self.Behaviour2)
        #nueva_prioridad = int(input("Introduce la nueva prioridad para Behaviour2: "))
        
        #self.change_behaviour_priority(self.Behaviour2, nueva_prioridad)
if __name__ == "__main__":
    spade.run(main())