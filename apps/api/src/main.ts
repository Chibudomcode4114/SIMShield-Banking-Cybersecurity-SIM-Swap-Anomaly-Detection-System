import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // Enable CORS for browser-to-BFF connectivity from Nuxt (Port 3000)
  app.enableCors({
    origin: '*',
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
  });

  const port = process.env.PORT_API ? parseInt(process.env.PORT_API, 10) : 3001;
  await app.listen(port);
  console.log(`[SIMShield BFF API] Listening on http://localhost:${port}`);
  console.log(`[SIMShield BFF API] Health check route: http://localhost:${port}/health`);
  console.log(`[SIMShield BFF API] Dependency check route: http://localhost:${port}/health/dependencies`);
}

bootstrap();
