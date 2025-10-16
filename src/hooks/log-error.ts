// For more information about this file see https://dove.feathersjs.com/guides/cli/log-error.html
import type { HookContext, NextFunction } from '../declarations'
import { logger } from '../logger'

export const logError = async (context: HookContext, next: NextFunction): Promise<void> => {
  try {
    await next()
  } catch (error: unknown) {
    logger.error((error as Error).stack)

    // Log validation errors
    if ((error as any).data) {
      logger.error('Data: %O', (error as any).data)
    }

    throw error
  }
}
