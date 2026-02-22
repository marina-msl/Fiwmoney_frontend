const BASE_URL = 'http://localhost:8080'

async function fetchStocks(walletId) {
  const token = localStorage.getItem('token')
  const response = await fetch(`${BASE_URL}/wallet/${walletId}`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  })
  if (!response.ok)
    throw new Error('Failed to fetch stocks')
  return await response.json()
}

async function addStock(walletId, newStock) {
  try {
    const token = localStorage.getItem('token')
    const response = await fetch(`${BASE_URL}/wallet/${walletId}/stocks`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(newStock),
    })

    if (response.status === 404) {
      throw new Error('Stock not found')
    }
    else if (response.status === 500) {
      throw new Error('Internal server error')
    }
    else if (!response.ok) {
      throw new Error('Failed to save stock')
    }
    return await response.json()
  }
  catch (error) {
    console.error('Stock service error: ', error.message)
    throw error
  }
}
// TODO send the id and boolean
// async function setNotify(id, isNotify ) {
async function setNotify(walletId, code, notify) {
  try {
    // TODO: Refactor to change to a better notify endpoint
    // const response = await fetch('http://localhost:8080/stock/id/notify', {
    const response = await fetch(`${BASE_URL}/wallet/{walletId}/notify`, {
      method: 'POST',
      headers: {
        'Content-type': 'application/json',
      },
      body: JSON.stringify({ code, notify }),
    })

    if (!response.ok) {
      throw new Error(`Erro ao atualizar notificação para ${code}`)
    }

    return await response.text()
  }
  catch (error) {
    // eslint-disable-next-line no-alert
    alert('Notify update failed: ', error.message)
    throw error
  }
}

export default {
  fetchStocks,
  addStock,
  setNotify,
}
