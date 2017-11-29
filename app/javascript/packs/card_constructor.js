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
            <div class="left">
              <div class="name">
                ${hit.name}
              </div>
              <div class="distance">
              </div>
            </div>
            <div class="right">
              <div class="price-per-day price">
                £${hit.price_per_day_pennies}<span>/day</span>
              </div>
              <div class="review-stars kill-padding">

                  <i class="fa fa-star gold-star" aria-hidden="true"></i>
                  <i class="fa fa-star gold-star" aria-hidden="true"></i>
                  <i class="fa fa-star gold-star" aria-hidden="true"></i>
                </div>
              </div>
            </div>
          </div>
        </a>
      </div>
    </div>`

  )}
}
