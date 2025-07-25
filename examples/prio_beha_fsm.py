import spade
import asyncio
from spade.message import Message
from spade.behaviour import FSMBehaviour, State

STATE_ONE = "STATE_ONE"
STATE_TWO = "STATE_TWO"
STATE_THREE = "STATE_THREE"

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
    class Behaviour1(spade.behaviour.CyclicBehaviour):
        async def run(self):
            # Implement the behaviour logic here
            #loop = asyncio.get_event_loop()
            ag = self.agent
            ag.contador1 = getattr(ag, 'contador1', 1)  # Use getattr to initialize contador1
            print(f"Running agent {self.agent.name}_{self.name} behaviour1 with priority: {self.priority}, contador1: {ag.contador1}")

            ag.contador1 += 1

class Behaviour2(spade.behaviour.FSMBehaviour):
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
        ag = self.agent
        ag.contador2 = getattr(ag, 'contador2', 1)  # Use getattr to initialize contador2
        print(f"Running agent {self.agent.name}_{self.name} behaviour2 with priority: {self.priority}, contador2: {ag.contador2}")

        ag.contador2 += 1
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
        self.fsm = self.Behaviour2(priority=2)
        self.fsm.add_state(name=STATE_ONE, state=StateOne(), initial=True)
        self.fsm.add_state(name=STATE_TWO, state=StateTwo())
        self.fsm.add_state(name=STATE_THREE, state=StateThree())
        self.fsm.add_transition(source=STATE_ONE, dest=STATE_TWO)
        self.fsm.add_transition(source=STATE_TWO, dest=STATE_THREE)
        self.b1 = self.Behaviour1(priority=1)
        
        self.b3 = self.Behaviour3(priority=3)
        self.add_behaviour(self.b1)
        self.add_behaviour(self.fsm)
        self.add_behaviour(self.b3)
    async def change_priority(self):
        print("se ha entrado en el metodo change_priority del agente")
        print("Self contador1:", self.contador1)
        if self.contador1 >= 5:
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