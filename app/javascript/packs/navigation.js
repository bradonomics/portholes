document.addEventListener('click', function(event) {

  // Main nav toggler for mobile devices
  if (event.target == document.querySelector('.responsive-menu-icon')) {
    event.preventDefault();
    mobileNavToggler();
  }

  // Sub-menu toggler (desktop)
  if (event.target == document.querySelector('.sub-menu-toggle')) {
    event.preventDefault();
    subMenuToggler();
  }

  // Clicking off the menu closes menu
  if (window.innerWidth >= 938) {
    if (event.target != document.querySelector('.sub-menu-toggle') && event.target != document.querySelector('.sub-menu')) {
      closeNavigation();
    }
  }

  // Pressing Esc closes menu
  document.onkeydown = function(event) {
    if (event.keyCode == 27) {
      closeNavigation();
    }
  };

});

window.mobileNavToggler = function() {
  // Main nav toggler for mobile devices
  var navigation = document.querySelector('.menu');

  // get the height of the element's inner content, regardless of its actual size
  var sectionHeight = navigation.scrollHeight;

  if (navigation.getAttribute('data-collapsed') === 'true') {
    // have the element transition to the height of its inner content
    navigation.style.height = sectionHeight + 'px';

    // mark Aria toggle button expanded as true
    document.querySelector('.responsive-menu-icon').setAttribute('aria-expanded', 'true');

    // set data-collapsed to false
    navigation.setAttribute('data-collapsed', 'false');

  } else {

    // temporarily disable all css transitions
    var elementTransition = navigation.style.transition;
    navigation.style.transition = '';

    // on the next frame (as soon as the previous style change has taken effect),
    // explicitly set the element's height to its current pixel height, so we
    // aren't transitioning out of 'auto'
    requestAnimationFrame(function() {
      navigation.style.height = sectionHeight + 'px';
      navigation.style.transition = elementTransition;

      // on the next frame (as soon as the previous style change has taken effect),
      // have the element transition to height: 0
      requestAnimationFrame(function() {
        navigation.style.height = 0 + 'px';
      });
    });

    // mark the section as "collapsed"
    navigation.setAttribute('data-collapsed', 'true');

    // mark Aria toggle button expanded as false
    document.querySelector('.responsive-menu-icon').setAttribute('aria-expanded', 'false');
  }
};

window.subMenuToggler = function() {
  // Sub-menu toggler (desktop)

  // Get the sub-menu
  var subNavigation = document.querySelector('.sub-menu');
  // Get the sub-menu-toggler
  var toggler = document.querySelector('.sub-menu-toggle');

  if (subNavigation.getAttribute('data-collapsed') == 'true') {
    openNavigation();
    return false;
  }

  if (subNavigation.getAttribute('data-collapsed') == 'false') {
    closeNavigation();
    return false;
  }

};

window.openNavigation = function() {
  // Get the sub-menu
  var subNavigation = document.querySelector('.sub-menu');
  // Get the sub-menu-toggler
  var toggler = document.querySelector('.sub-menu-toggle');


  // Add class `expanded` to .sub-menu
  subNavigation.className += ' expanded';

  // Add class `expanded` to .sub-menu-toggle
  toggler.className += ' expanded';

  // mark Aria toggle button expanded as true
  toggler.setAttribute('aria-expanded', 'true');

  // set data-collapsed to false
  subNavigation.setAttribute('data-collapsed', 'false');
};

window.closeNavigation = function() {
  // Get the sub-menu
  var subNavigation = document.querySelector('.sub-menu');
  // Get the sub-menu-toggler
  var toggler = document.querySelector('.sub-menu-toggle');

  // Remove expanded class from .sub-menu
  subNavigation.classList.remove('expanded');

  // Remove expanded class from .sub-menu-toggler
  toggler.classList.remove('expanded');

  // mark the section as collapsed
  subNavigation.setAttribute('data-collapsed', 'true');

  // mark Aria toggle button expanded as false
  toggler.setAttribute('aria-expanded', 'false');
};
