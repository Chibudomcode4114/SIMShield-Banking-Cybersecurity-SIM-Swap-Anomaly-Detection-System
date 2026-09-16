import { Controller, Get, Res, HttpStatus } from '@nestjs/common';
import { HealthService } from './health.service';

@Controller('health')
export class HealthController {
  constructor(private readonly healthService: HealthService) {}

  @Get()
  async getSelfHealth() {
    return this.healthService.checkSelf();
  }

  @Get('dependencies')
  async getDependencyHealth(@Res() res: any) {
    const report = await this.healthService.checkDependencies();
    const httpStatus = report.status === 'unhealthy' ? HttpStatus.SERVICE_UNAVAILABLE : HttpStatus.OK;
    return res.status(httpStatus).json(report);
  }
}
