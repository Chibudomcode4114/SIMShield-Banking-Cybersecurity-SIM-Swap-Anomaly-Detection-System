<template>
  <div class="simshield-container">
    <header class="header">
      <div class="header-content">
        <div class="branding">
          <span class="shield-badge">🛡️ SIMShield</span>
          <span class="env-tag">DAY 2 BASELINE</span>
        </div>
        <div class="actor-tag">
          Role: <strong>Bank Fraud / Security Analyst</strong>
        </div>
      </div>
    </header>

    <main class="main-content">
      <section class="hero-card">
        <h1>Banking Cybersecurity & SIM-Swap Anomaly Detection</h1>
        <p class="subtitle">
          Detecting suspicious SIM/device changes within telecom channels before fraudulent banking transactions can complete.
        </p>
        <div class="meta-row">
          <span>Target Metric: <strong>Sub-second risk classification</strong></span>
          <span>Risk Tier: <strong>High (Synthetic banking data only)</strong></span>
          <span>Baseline Mode: <strong>Local Resource-Constrained Profile</strong></span>
        </div>
      </section>

      <!-- Degraded State Banner (Phase G requirement) -->
      <section v-if="bffStatus && bffStatus.status === 'degraded'" class="alert-banner warning">
        <div class="alert-icon">⚠️</div>
        <div class="alert-text">
          <strong>Degraded Topology State Detected:</strong>
          <span>Optional AI Service (FastAPI :8000) is currently offline or unreachable. Core BFF operations remain active.</span>
        </div>
      </section>

      <section v-else-if="bffStatus && bffStatus.status === 'unhealthy'" class="alert-banner danger">
        <div class="alert-icon">🛑</div>
        <div class="alert-text">
          <strong>Unhealthy Topology State:</strong>
          <span>Core database or critical dependencies are offline. Check MySQL (:3307) or Weaviate (:8080).</span>
        </div>
      </section>

      <section v-else-if="bffStatus && bffStatus.status === 'healthy'" class="alert-banner success">
        <div class="alert-icon">✅</div>
        <div class="alert-text">
          <strong>All Five Services Healthy & Connected:</strong>
          <span>Browser-to-BFF and BFF-to-downstream dependency verification passed.</span>
        </div>
      </section>

      <!-- 5-Service Topology Status Grid -->
      <section class="services-section">
        <h2>Service Topology Status (Day 2 Acceptance Contracts)</h2>
        <div class="cards-grid">
          <!-- 1. Web Shell -->
          <div class="card service-card healthy">
            <div class="card-header">
              <span class="service-name">Web Application</span>
              <span class="status-pill green">ONLINE</span>
            </div>
            <div class="card-body">
              <p><strong>Port:</strong> 3000 (Host)</p>
              <p><strong>Runtime:</strong> Nuxt 3 / Vue 3 / TS</p>
              <p><strong>Boundary:</strong> User Interface Shell</p>
              <p class="service-note">Rendering Fraud Analyst Console</p>
            </div>
          </div>

          <!-- 2. NestJS BFF -->
          <div class="card service-card" :class="getServiceClass('bff')">
            <div class="card-header">
              <span class="service-name">NestJS BFF / API</span>
              <span class="status-pill" :class="getStatusPillClass('bff')">{{ getServiceStatusText('bff') }}</span>
            </div>
            <div class="card-body">
              <p><strong>Port:</strong> 3001 (Host)</p>
              <p><strong>Runtime:</strong> NestJS on Node.js 22</p>
              <p><strong>Boundary:</strong> Orchestration & API Gateway</p>
              <p class="service-note">{{ bffStatus ? bffStatus.truthfulStatement : 'Probing BFF...' }}</p>
            </div>
          </div>

          <!-- 3. FastAPI AI Service -->
          <div class="card service-card" :class="getServiceClass('fastapi')">
            <div class="card-header">
              <span class="service-name">FastAPI AI Service</span>
              <span class="status-pill" :class="getStatusPillClass('fastapi')">{{ getServiceStatusText('fastapi') }}</span>
            </div>
            <div class="card-body">
              <p><strong>Port:</strong> 8000 (Host)</p>
              <p><strong>Runtime:</strong> FastAPI on Python 3.13</p>
              <p><strong>Boundary:</strong> Anomaly & Risk Contract</p>
              <p class="service-note">{{ getAiCapabilityNote() }}</p>
            </div>
          </div>

          <!-- 4. MySQL Database -->
          <div class="card service-card" :class="getServiceClass('mysql')">
            <div class="card-header">
              <span class="service-name">MySQL Database</span>
              <span class="status-pill" :class="getStatusPillClass('mysql')">{{ getServiceStatusText('mysql') }}</span>
            </div>
            <div class="card-body">
              <p><strong>Port:</strong> 3307 (Host) -> 3306</p>
              <p><strong>Runtime:</strong> MySQL 8.0 / Prisma Schema</p>
              <p><strong>Boundary:</strong> Transactional Domain Store</p>
              <p class="service-note">Accounts, Events, Risk Assessments</p>
            </div>
          </div>

          <!-- 5. Weaviate Vector DB -->
          <div class="card service-card" :class="getServiceClass('weaviate')">
            <div class="card-header">
              <span class="service-name">Weaviate Vector DB</span>
              <span class="status-pill" :class="getStatusPillClass('weaviate')">{{ getServiceStatusText('weaviate') }}</span>
            </div>
            <div class="card-body">
              <p><strong>Port:</strong> 8080 (Host)</p>
              <p><strong>Runtime:</strong> Weaviate 1.25</p>
              <p><strong>Boundary:</strong> Fraud Pattern Vector Store</p>
              <p class="service-note">Schema: FraudPattern (Metadata-governed)</p>
            </div>
          </div>
        </div>
      </section>

      <!-- Day 3 Interface Seams & Backlog -->
      <section class="backlog-section">
        <h2>Day 3 Interface Backlog (Seams Left Ready)</h2>
        <div class="backlog-grid">
          <div class="backlog-item">
            <h3>1. Telecom SIM-Swap Stream</h3>
            <p>Real-time feed simulator for MSISDN / IMSI replacement events.</p>
          </div>
          <div class="backlog-item">
            <h3>2. Anomaly Classification Card</h3>
            <p>Low / Medium / High / Critical classification with step-up authentication prompts.</p>
          </div>
          <div class="backlog-item">
            <h3>3. Transaction Hold Panel</h3>
            <p>Manual analyst intervention and automated 15-minute hold triggers for high-risk swaps.</p>
          </div>
        </div>
      </section>
    </main>

    <footer class="footer">
      <p>SIMShield Baseline v0.1.0 • Verified Local Environment • Day 2 Acceptance Gate</p>
    </footer>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const bffStatus = ref(null)
const lastChecked = ref(null)
const apiBase = ref('http://localhost:3001')

async function fetchHealth() {
  try {
    const res = await fetch(`${apiBase.value}/health/dependencies`)
    if (res.ok || res.status === 207) {
      bffStatus.value = await res.json()
    } else {
      bffStatus.value = { status: 'unhealthy', dependencies: {} }
    }
  } catch (e) {
    bffStatus.value = {
      status: 'unhealthy',
      truthfulStatement: 'Cannot connect to NestJS BFF API on port 3001.',
      dependencies: {
        mysql: { status: 'unavailable' },
        weaviate: { status: 'unavailable' },
        fastapi: { status: 'unavailable' }
      }
    }
  }
  lastChecked.value = new Date().toLocaleTimeString()
}

function getServiceStatusText(serviceKey) {
  if (!bffStatus.value) return 'CHECKING...'
  if (serviceKey === 'bff') return bffStatus.value.status.toUpperCase()
  const dep = bffStatus.value.dependencies?.[serviceKey]
  return dep ? dep.status.toUpperCase() : 'UNKNOWN'
}

function getStatusPillClass(serviceKey) {
  const status = getServiceStatusText(serviceKey)
  if (status === 'HEALTHY' || status === 'ONLINE') return 'green'
  if (status === 'DEGRADED') return 'yellow'
  return 'red'
}

function getServiceClass(serviceKey) {
  const status = getServiceStatusText(serviceKey)
  if (status === 'HEALTHY' || status === 'ONLINE') return 'healthy'
  if (status === 'DEGRADED') return 'degraded'
  return 'unhealthy'
}

function getAiCapabilityNote() {
  if (!bffStatus.value?.dependencies?.fastapi) return 'FastAPI capability probing...'
  const fa = bffStatus.value.dependencies.fastapi
  if (fa.status === 'healthy') {
    return 'Status: Healthy. AI Capabilities: standing_by (Truthful baseline)'
  }
  return 'Service unavailable or degraded.'
}

onMounted(() => {
  fetchHealth()
  setInterval(fetchHealth, 5000)
})
</script>

<style scoped>
.simshield-container {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
  color: #1a202c;
  background-color: #f7fafc;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.header {
  background: #1a365d;
  color: white;
  padding: 1rem 2rem;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.branding {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.shield-badge {
  font-size: 1.35rem;
  font-weight: 700;
  letter-spacing: -0.025em;
}

.env-tag {
  background: #2b6cb0;
  font-size: 0.75rem;
  padding: 0.2rem 0.6rem;
  border-radius: 9999px;
  font-weight: 600;
}

.actor-tag {
  font-size: 0.9rem;
  background: rgba(255,255,255,0.1);
  padding: 0.35rem 0.8rem;
  border-radius: 6px;
}

.main-content {
  max-width: 1200px;
  margin: 2rem auto;
  padding: 0 1.5rem;
  flex: 1;
  width: 100%;
}

.hero-card {
  background: white;
  padding: 2rem;
  border-radius: 12px;
  box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
  margin-bottom: 2rem;
  border-left: 6px solid #3182ce;
}

.hero-card h1 {
  margin: 0 0 0.5rem;
  font-size: 1.75rem;
  color: #2d3748;
}

.subtitle {
  color: #4a5568;
  font-size: 1.1rem;
  margin: 0 0 1.5rem;
}

.meta-row {
  display: flex;
  gap: 2rem;
  flex-wrap: wrap;
  font-size: 0.9rem;
  color: #718096;
}

.alert-banner {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem 1.5rem;
  border-radius: 8px;
  margin-bottom: 2rem;
  font-size: 0.95rem;
}

.alert-banner.success {
  background: #c6f6d5;
  color: #22543d;
  border: 1px solid #9ae6b4;
}

.alert-banner.warning {
  background: #feebc8;
  color: #744210;
  border: 1px solid #fbd38d;
}

.alert-banner.danger {
  background: #fed7d7;
  color: #742a2a;
  border: 1px solid #feb2b2;
}

.alert-icon {
  font-size: 1.5rem;
}

.services-section h2, .backlog-section h2 {
  font-size: 1.35rem;
  color: #2d3748;
  margin-bottom: 1.25rem;
}

.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 1.25rem;
  margin-bottom: 2.5rem;
}

.card {
  background: white;
  border-radius: 10px;
  padding: 1.25rem;
  box-shadow: 0 2px 4px rgba(0,0,0,0.04);
  border: 1px solid #e2e8f0;
  transition: transform 0.2s, box-shadow 0.2s;
}

.card.healthy {
  border-top: 4px solid #38a169;
}

.card.degraded {
  border-top: 4px solid #d69e2e;
}

.card.unhealthy {
  border-top: 4px solid #e53e3e;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.75rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid #edf2f7;
}

.service-name {
  font-weight: 600;
  font-size: 1rem;
}

.status-pill {
  font-size: 0.7rem;
  font-weight: 700;
  padding: 0.2rem 0.5rem;
  border-radius: 9999px;
}

.status-pill.green {
  background: #c6f6d5;
  color: #22543d;
}

.status-pill.yellow {
  background: #feebc8;
  color: #744210;
}

.status-pill.red {
  background: #fed7d7;
  color: #742a2a;
}

.card-body p {
  margin: 0.35rem 0;
  font-size: 0.85rem;
  color: #4a5568;
}

.service-note {
  font-style: italic;
  font-size: 0.8rem !important;
  color: #718096 !important;
  margin-top: 0.5rem !important;
}

.backlog-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.25rem;
}

.backlog-item {
  background: white;
  padding: 1.25rem;
  border-radius: 8px;
  border-left: 4px solid #4299e1;
  box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}

.backlog-item h3 {
  margin: 0 0 0.5rem;
  font-size: 1.05rem;
  color: #2b6cb0;
}

.backlog-item p {
  margin: 0;
  font-size: 0.9rem;
  color: #4a5568;
}

.footer {
  background: #edf2f7;
  text-align: center;
  padding: 1.5rem;
  font-size: 0.85rem;
  color: #718096;
}
</style>
