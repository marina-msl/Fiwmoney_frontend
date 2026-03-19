const BASE_URL = 'http://localhost:8080'

async function fetchStocks(walletId) {
  const token = localStorage.getItem('token')
  const response = await fetch(`${BASE_URL}/wallet/${walletId}`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  })
  if (!response.ok) {
    const err = new Error(response.status === 403
      ? 'Access denied (403). Session may have expired.'
      : 'Failed to fetch stocks')
    err.status = response.status
    throw err
  }
  return await response.json()
}

async function addStock(walletId, newStock) {
  try {
    const token = localStorage.getItem('token')
    const response = await fetch(`${BASE_URL}/wallet/${walletId}/stock`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(newStock),
    })

    if (response.status === 403) {
      const err = new Error('Access denied (403). Try logging out and logging in again.')
      err.status = 403
      throw err
    }
    if (response.status === 404) {
      throw new Error('Stock not found')
    }
    if (response.status === 500) {
      let message = 'Internal server error'
      try {
        const body = await response.json()
        message = body.message || body.error || message
      }
      catch {
      }
      throw new Error(message)
    }
    if (!response.ok) {
      throw new Error('Failed to save stock')
    }
    return await response.json()
  }
  catch (error) {
    console.error('Stock service error: ', error.message)
    throw error
  }
}

async function updateAveragePrice(walletId, code, averagePrice) {
  const token = localStorage.getItem('token')
  const response = await fetch(`${BASE_URL}/wallet/${walletId}/stock/${encodeURIComponent(code)}`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`,
    },
    body: JSON.stringify({ averagePrice }),
  })

  if (!response.ok) {
    if (response.status === 404) {
      throw new Error('Stock not found')
    }
    throw new Error('Failed to update average price')
  }

  return await response.json()
}

async function deleteStock(walletId, code) {
  const token = localStorage.getItem('token')
  const response = await fetch(`${BASE_URL}/wallet/${walletId}/stock/${encodeURIComponent(code)}`, {
    method: 'DELETE',
    headers: {
      Authorization: `Bearer ${token}`,
    },
  })
  if (!response.ok) {
    if (response.status === 404) {
      throw new Error('Stock not found')
    }
    throw new Error('Failed to delete stock')
  }
}

async function setNotify(walletId, stock) {
  const token = localStorage.getItem('token')
  const response = await fetch(`${BASE_URL}/wallet/${walletId}/stock/${encodeURIComponent(stock.code)}/notify`, {
    method: 'PATCH',
    headers: {
      'Content-type': 'application/json',
      'Authorization': `Bearer ${token}`,
    },
    body: JSON.stringify(stock),
  })

  if (!response.ok) {
    let reason = `status ${response.status}`
    try {
      const body = await response.json()
      reason = body.message || body.error || reason
    }
    catch { }
    throw new Error(`Failed to update notification for ${stock.code}: ${reason}`)
  }

  return await response.text()
}

export default {
  fetchStocks,
  addStock,
  updateAveragePrice,
  deleteStock,
  setNotify,
}
