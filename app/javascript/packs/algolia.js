const client = algoliasearch("3QRXVE4VDT", "0448f9b83bca12989799aaf181b86677");
const index = client.initIndex('Product');
const container = document.getElementById('card-row');
const form = document.getElementById('search');

function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

$(document).ready(()=> {
  const params = getParameterByName('search')
  form.value = params;
  algoliaSearch();
});

const algoliaSearch = () => {
  container.innerHTML = "";
  query = form.value;
  // query the algolia api for search results
  index.search(query, function searchDone(err, content) {
    if (err) {
      console.error(err);
      return;
    }

    // updates the counter at the top of the page
    counter = document.getElementById('counter');
    counter.innerHTML = `<h1>${content.hits.length} Search results in your area...</h1>`;

    content.hits.forEach( product => {
      // Appends a new card to the cards container for every search result.
      container.insertAdjacentHTML('beforeend', `
        <div class="col-xs-12 col-sm-6">
          <div class="card">
            <a class='link-to-product' href='http://localhost:3000/products/${product.objectID}/'>
              <div class='card-body' style='background-image: url(${product['photo']})'></div>
              <div class="card-footer">
                <div class="container">
                  <div class="row">
                    <div class="col-xs-12 col-lg-6">
                      <span class="description">${product["name"]}</span>
                    </div>
                    <div class="col-xs-12 col-lg-6">
                      <span class="price">£${product["price_per_day"]}/day</span>
                    </div>
                  </div>
                </div>
              </div>
            </a>
          </div>
        </div>`);
    });
  });
};

form.addEventListener('keyup', (event) => {
  algoliaSearch();
})

