module Test.Main where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.Traverse (forEachEff, traverseEff)
import Control.Monad.ST (pureST)
import Data.Array (length, range)
import Data.Array.ST (emptySTArray, pushSTArray, unsafeFreeze)
import Data.Int (odd)
import Data.Record.ST (freezeSTRecord, modify, thawSTRecord)
import Data.Symbol (SProxy(..))
import Data.Traversable (class Traversable)
import Test.Assert (ASSERT, assert)

main :: forall e. Eff (console :: CONSOLE, assert :: ASSERT | e) Unit
main = do
  log "traverseEff should be correct"
  assert $ scanl (+) 0 [0, 1, 2, 3] == [0, 1, 3, 6]

  log "traverseEff should be stack safe"
  let longLength = 10000000
  assert $ length (scanl (+) 0 $ range 1 longLength) == longLength

  log "forEachEff should be correct"
  let counts = countPredicate odd (range 0 longLength)
  assert $ counts.trues == 5000000
  assert $ counts.falses == 5000001

-- implement scanl on `Array` in terms of `traverseEff`
scanl :: forall a b. (b -> a -> b) -> b -> Array a -> Array b
scanl f acc xs = pureST do
  arr <- emptySTArray
  let eff b a = do
              let b' = f b a
              _ <- pushSTArray arr b'
              pure b'
  _ <- traverseEff eff acc xs
  unsafeFreeze arr

countPredicate
  :: forall f a
   . Traversable f
  => (a -> Boolean) -> f a -> { trues :: Int, falses :: Int }
countPredicate pred xs = pureST do
  counts <- thawSTRecord { trues: 0, falses: 0 }
  forEachEff xs \x ->
    if pred x
      then modify (SProxy :: SProxy "trues") (_ + 1) counts
      else modify (SProxy :: SProxy "falses") (_ + 1) counts
  freezeSTRecord counts
