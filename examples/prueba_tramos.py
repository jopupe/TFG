import asyncio
import spade
from PriorityAsyncio.base_events import PrioritizedEventLoop
import PriorityAsyncio.tasks
import PriorityAsyncio.locks
import random
import time
start_agents = PriorityAsyncio.locks.PrioritizedEvent(priority=-600)

class Agent(spade.agent.Agent):
    class R(spade.behaviour.CyclicBehaviour):
        async def run(self):
            await start_agents.wait()
            agent = self.agent
            if agent.missing_length <= 0:
                self.kill()
            
            time.sleep(0.2)  # Simula el tiempo de recorrido del tramo
            self.stretchs = getattr(self, 'stretchs', 0)
            self.stretchs += 1
            agent.missing_length = agent.missing_length - agent.next_stretch
            self.tramos_siguientes = []
            for ag in self.agent.container.get_agents():
                if ag.missing_length < 500:
                    ag.next_stretch = ag.missing_length
                    self.tramos_siguientes.append(ag.next_stretch)
                else:
                    ag.next_stretch = random.randint(1, 500)
                    self.tramos_siguientes.append(ag.next_stretch)
        
    async def setup(self):
        self.missing_length = 10000
        self.next_stretch = random.randint(1,500)
        self.primera_prioridad = -self.next_stretch
        self.beh = self.R(priority=self.primera_prioridad)
        self.tramos_siguientes = []
        self.add_behaviour(self.beh)
        self.prioridad_cambiada = False
        print("{} ready.".format(self.name))
    
    async def change_priority(self):
        for ag in self.container.get_agents():
            if max(self.beh.tramos_siguientes) == ag.next_stretch:
                ag.change_behaviour_priority_forever(ag.beh, ag.primera_prioridad)
                ag.prioridad_cambiada = True
            elif max(self.beh.tramos_siguientes) > ag.next_stretch and ag.get_beh_priority(ag.beh) != 1:
                ag.change_behaviour_priority_forever(ag.beh, 1)
                ag.prioridad_cambiada = True


async def main():
    num_experimentos = 1
    total_tramos_prueba = 0
    iteraciones_en_cada_prueba = []
    tiempos_pruebas = []
    for j in range(0, num_experimentos):
        num_agents = 10
        agentes = []
        for i in range(1,num_agents):
            print("Creating agent {}".format(i))
            agent = Agent("ag_{}@localhost".format(i), "your_password")
            await agent.start()
            agentes.append(agent)
        print("hora comienzo:", time.strftime("%H:%M:%S"))
        start_time = time.time()
        start_agents.set()
        
        while True:
            try:
                await asyncio.sleep(1)
                status = []
                for agent in agentes:
                    status.append(agent.missing_length)
                print("missing lengths: ", status)
                if max(status) <= 0:
                    print("All agents have completed their tasks.")
                    break
            except KeyboardInterrupt:
                break
        start_agents.clear()
        for agent in agentes:
            await agent.stop()
        print("hora fin:", time.strftime("%H:%M:%S"))
        elapsed_time = time.time() - start_time
        total_tramos_corridos_iteracion = sum(ag.beh.stretchs for ag in agentes)
        iteraciones_en_cada_prueba.append(total_tramos_corridos_iteracion)
        total_tramos_prueba = total_tramos_prueba + total_tramos_corridos_iteracion
        tiempos_pruebas.append(elapsed_time)
        print("Total tramos corridos: ", total_tramos_corridos_iteracion, "en la prueba:", j)
    print("----------------------------------------------")
    print("Total tramos corridos en todas las pruebas: ", total_tramos_prueba)
    print("Iteraciones en cada prueba: ", iteraciones_en_cada_prueba)
    print("Tiempo de prueba en cada iteración: ", tiempos_pruebas)
if __name__ == "__main__":
    spade.run(main())