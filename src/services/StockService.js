const BASE_URL = 'http://localhost:8080';

async function fetchStocks() {
    const response = await fetch (`${BASE_URL}/stocks`);
    if (!response.ok) throw new Error ('Failed to fetch stocks');
    return await response.json();
}

async function addStock(newStock) {
    try {
        const response = await fetch(`${BASE_URL}/stocks`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(newStock)
        });

        if (response.status == 404) {
            throw new Error('Stock not found');
        } else if (response.status == 500) {
            throw new Error('Internal server error');
        } else if (!response.ok) {
            throw new Error('Failed to save stock');
        }
        return await response.json();
    } catch (error) {
        console.error('Stock service error: ', error.message);
        throw error;
    }
}

export default {
    fetchStocks,
    addStock
};