import fastify from "fastify";
import { prisma } from "@repo/db";

const server = fastify();

const getUsers = async () => {
  const users = await prisma.user.findMany();
  return users;
};

server.get("/users", async (request, reply) => {
  return getUsers();
});

server.listen({ port: 3001 }, (err, address) => {
  if (err) {
    console.error(err);
    process.exit(1);
  }
  console.log(`Server listening at ${address}`);
});
