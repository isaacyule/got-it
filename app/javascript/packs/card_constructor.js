module.exports = {
  constructCard: function(hit) {
    var starsContainer = document.getElementById('stars');
    var avgRating;
    console.log(hit.rating);
    if (typeof hit.rating === 'undefined' || typeof hit.rating === null){
      console.log("its zero guys");
      avgRating = "Not yet rated"
    } else {
      avgRating = "";
      for(var i=0; i<hit.rating; i++){
        avgRating = avgRating + '<i class="fa fa-star gold-star" aria-hidden="true"></i> ';
      }
      avgRating = avgRating + " " + "(" + (hit.rating_count) + ")";
    }
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
              <div class="review-stars kill-padding" id="stars">
                  <p class="rating">${avgRating}</p>
                </div>
              </div>
            </div>
          </div>
        </a>
      </div>
    </div>`

  )}
}
