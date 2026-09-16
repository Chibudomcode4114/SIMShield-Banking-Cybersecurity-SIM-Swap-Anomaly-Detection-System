import { Injectable } from '@nestjs/common';
import * as net from 'net';

export interface DependencyStatus {
  status: 'healthy' | 'degraded' | 'unavailable';
  latencyMs?: number;
  details?: any;
  error?: string;
}

export interface HealthReport {
  service: string;
  version: string;
  timestamp: string;
  status: 'healthy' | 'degraded' | 'unhealthy';
  dependencies: {
    mysql: DependencyStatus;
    weaviate: DependencyStatus;
    fastapi: DependencyStatus;
  };
  truthfulStatement: string;
}

@Injectable()
export class HealthService {
  private readonly mysqlHost = process.env.MYSQL_HOST || 'localhost';
  private readonly mysqlPort = parseInt(process.env.MYSQL_PORT || '3307', 10);
  private readonly weaviateUrl = process.env.WEAVIATE_URL || 'http://localhost:8080';
  private readonly fastApiUrl = process.env.AI_SERVICE_URL || 'http://localhost:8000';

  async checkSelf(): Promise<{ service: string; version: string; status: string; timestamp: string }> {
    return {
      service: 'simshield-api',
      version: '0.1.0',
      status: 'healthy',
      timestamp: new Date().toISOString(),
    };
  }

  async checkDependencies(): Promise<HealthReport> {
    const [mysqlStatus, weaviateStatus, fastApiStatus] = await Promise.all([
      this.probeMysql(),
      this.probeWeaviate(),
      this.probeFastApi(),
    ]);

    let aggregatedStatus: 'healthy' | 'degraded' | 'unhealthy' = 'healthy';
    if (mysqlStatus.status !== 'healthy' || weaviateStatus.status !== 'healthy') {
      aggregatedStatus = 'unhealthy';
    } else if (fastApiStatus.status !== 'healthy') {
      aggregatedStatus = 'degraded';
    }

    return {
      service: 'simshield-api',
      version: '0.1.0',
      timestamp: new Date().toISOString(),
      status: aggregatedStatus,
      dependencies: {
        mysql: mysqlStatus,
        weaviate: weaviateStatus,
        fastapi: fastApiStatus,
      },
      truthfulStatement: 'BFF verified downstream boundaries. Future AI inference capabilities are deferred to Days 8-15.',
    };
  }

  private async probeMysql(): Promise<DependencyStatus> {
    const start = Date.now();
    return new Promise((resolve) => {
      const socket = new net.Socket();
      socket.setTimeout(2000);

      socket.on('connect', () => {
        const latency = Date.now() - start;
        socket.destroy();
        resolve({
          status: 'healthy',
          latencyMs: latency,
          details: { host: this.mysqlHost, port: this.mysqlPort, protocol: 'tcp/mysql' },
        });
      });

      socket.on('timeout', () => {
        socket.destroy();
        resolve({
          status: 'unavailable',
          error: 'Connection timed out',
        });
      });

      socket.on('error', (err) => {
        resolve({
          status: 'unavailable',
          error: err.message,
        });
      });

      socket.connect(this.mysqlPort, this.mysqlHost);
    });
  }

  private async probeWeaviate(): Promise<DependencyStatus> {
    const start = Date.now();
    try {
      const response = await fetch(`${this.weaviateUrl}/v1/.well-known/ready`, {
        signal: AbortSignal.timeout(2000),
      });
      const latency = Date.now() - start;
      if (response.ok) {
        return {
          status: 'healthy',
          latencyMs: latency,
          details: { endpoint: '/v1/.well-known/ready', statusCode: response.status },
        };
      }
      return {
        status: 'degraded',
        latencyMs: latency,
        error: `Unexpected status: ${response.status}`,
      };
    } catch (err: any) {
      return {
        status: 'unavailable',
        error: err.message,
      };
    }
  }

  private async probeFastApi(): Promise<DependencyStatus> {
    const start = Date.now();
    try {
      const response = await fetch(`${this.fastApiUrl}/health`, {
        signal: AbortSignal.timeout(2000),
      });
      const latency = Date.now() - start;
      if (response.ok) {
        const data = await response.json();
        return {
          status: 'healthy',
          latencyMs: latency,
          details: {
            service: data.service,
            capabilities: data.capabilities,
          },
        };
      }
      return {
        status: 'degraded',
        latencyMs: latency,
        error: `FastAPI responded with HTTP ${response.status}`,
      };
    } catch (err: any) {
      return {
        status: 'unavailable',
        error: err.message || 'Connection refused',
      };
    }
  }
}
