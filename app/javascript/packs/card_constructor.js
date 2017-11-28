module.exports = {
  constructCard: function(hit) {
    return(
     `
      <div class="col-xs-12 col-sm-6">
        <div class="card">
          <a class='link-to-product' href='https://got-it-wagon.herokuapp.com/products/${hit.objectID}/'>
            <div class='card-body'>
              <div class='photo' style='background-image: url(${hit.photo})'>
                <div class='card-avatar' style='background-image: url(${hit.owner_photo})'></div>
              </div>
            </div>
            <div class="card-footer">
              <div class="container footer-container">
                <div class="row footer-row">
                  <div class="col-xs-12">
                    <span class="description">${hit.name}</span>
                  </div>
                  <div class="col-xs-12 col-md-4">
                    <span class="review-stars kill-padding">
                      ${hit.average_rating}<i class="fa fa-star gold-star" aria-hidden="true"></i><i class="fa fa-star gold-star" aria-hidden="true"></i><i class="fa fa-star gold-star" aria-hidden="true"></i><span class='black'></span>
                    </span>
                  </div>
                  <div class="col-xs-12 col-md-4">
                    <span class="distance">.</span>
                  </div>
                </div>
                <div class="price-per-day">
                  <span class="price">£${hit.price_per_day_pennies}/day</span>
                </div>
              </div>
            </div>
          </a>
        </div>
      </div>`
  )}
}
