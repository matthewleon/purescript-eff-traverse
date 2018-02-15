"use strict";

exports.traverseEffImpl = (function () {
  function performEff (f) {
    return function (b) {
      return function (a) {
        return f(b)(a)();
      };
    };
  }

  return function (foldl) {
    return function (f) {
      return function (acc) {
        return function (xs) {
          return function () {
            foldl(performEff(f))(acc)(xs);
          };
        };
      };
    };
  };
})();
