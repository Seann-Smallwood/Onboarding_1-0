// For more information about this file see https://dove.feathersjs.com/guides/cli/databases.html

// Direct configuration based on environment
const env = process.env.NODE_ENV || 'default'

let config

if (env === 'test') {
  // Use SQLite for testing
  config = {
    client: 'sqlite3',
    connection: ':memory:',
    useNullAsDefault: true
  }
} else {
  // Use PostgreSQL for development/production
  config = {
    client: 'pg',
    connection: {
      host: 'localhost',
      port: 5432,
      database: 'Onboard1_0',
      user: 'postgres',
      password: ''
    }
  }
}

module.exports = config
