module Control.Monad.Eff.Traverse 
  ( traverseEff
  , forEachEff
  ) where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Foldable (foldl)
import Data.Traversable (class Traversable)

traverseEff
  :: forall a b f eff
   . Traversable f
  => (b -> a -> Eff eff b) -> b -> f a -> Eff eff b
traverseEff = traverseEffImpl foldl

foreign import traverseEffImpl
  :: forall a b f eff
   . ((b -> a -> b) -> b -> f a -> b)
  -> (b -> a -> Eff eff b) -> b -> f a -> Eff eff b

forEachEff
  :: forall a f eff
   . Traversable f
  => f a -> (a -> Eff eff Unit) -> Eff eff Unit
forEachEff xs f = traverseEff (const f) unit xs
