const BASE_URL = 'http://localhost:8080';

async function fetchStocks() {
    const response = await fetch (`${BASE_URL}/stocks`);
    if (!response.ok) throw new Error ('Failed to fetch stocks');
    return await response.json();
}

export default {
    fetchStocks
};