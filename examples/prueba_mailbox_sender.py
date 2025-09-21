import spade
import  asyncio
import spade
from PriorityAsyncio.base_events import PrioritizedEventLoop
import PriorityAsyncio.tasks
import PriorityAsyncio.locks
import random
import time
total_messages_sent = 0
mensajes_sin_recibir = 0
total_messages_replied = 0
start_agents = PriorityAsyncio.locks.PrioritizedEvent(priority=-600)

class Sender(spade.agent.Agent):

    async def setup(self):
        self.send = self.Send(priority=1)
        self.add_behaviour(self.send)
        print("{} ready.".format(self.name))
    class Send(spade.behaviour.CyclicBehaviour):

        async def run(self):
            await start_agents.wait()
            global total_messages_sent
            global mensajes_sin_recibir
            total_messages_sent += 1
            msg =spade.message.Message(to="ag_rec@localhost", body="Mensaje {} de {}".format(total_messages_sent, self.agent.name))
            loop = asyncio.get_event_loop()
            task = loop.create_task(self.send(msg))
            
            await task
            mensajes_sin_recibir += 1
            
    #"""
    async def change_priority(self):
        
        rec_ag = self.container.get_agent("ag_rec@localhost")
        if mensajes_sin_recibir >= 50:
            
            rec_ag.change_behaviour_priority_forever(rec_ag.receive, -2)
            
    #"""
    
        


class Receiver(spade.agent.Agent):

    async def setup(self):
        self.receive = self.Receive(priority=2)
        self.add_behaviour(self.receive)
        self.reply = self.Reply(priority=5)
        self.add_behaviour(self.reply)
        self.list_msg = []
        print("{} ready.".format(self.name))
    class Receive(spade.behaviour.CyclicBehaviour):

        async def run(self):
            await start_agents.wait()
            global mensajes_sin_recibir
            ag = self.agent
            loop = asyncio.get_event_loop()
            task = loop.create_task(self.receive(timeout=100))
            msg = await task
            if msg:
                ag.list_msg.append(msg)
                mensajes_sin_recibir -= 1

    #"""
    async def change_priority(self):

        if self.receive.msg_not_replied() >= 75:
            self.change_behaviour_priority_forever(self.reply, -5)
        
        if self.receive.msg_not_replied() - self.receive.mailbox_size() == 0:
            self.change_behaviour_priority_forever(self.reply, 5)
        
        if mensajes_sin_recibir == 0:
            self.change_behaviour_priority_forever(self.receive, 2)
    #"""
    
        

    class Reply(spade.behaviour.CyclicBehaviour):
        async def run(self):
            await start_agents.wait()
            global total_messages_replied
            ag = self.agent
            for msg in ag.list_msg:
                reply = spade.message.Message(to=str(msg.sender), body="Reply to: {}".format(msg.body))
                await self.send(reply)
                ag.list_msg.remove(msg)
                total_messages_replied += 1
                ag.receive.queue.task_done()

async def main():
    num_sender_agents = 5
    agentes = []
    for i in range(num_sender_agents):
        print("Creando agente: ag_send_{}@localhost".format(i))
        agente = Sender("ag_send_{}@localhost".format(i), "your_password")
        await agente.start()
        agentes.append(agente)
    rec_agent = Receiver("ag_rec@localhost", "your_password")
    await rec_agent.start()
    start_agents.set()

    await asyncio.sleep(5)
    
    start_agents.clear()
    for agente in agentes:
        await agente.stop()
    print("All agents stopped.")
    
if __name__ == "__main__":
    spade.run(main())