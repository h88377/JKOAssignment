# JKOAssignment
## App architecture
Note: 
Please refer to the `App architecture diagram.drawio` file if you would like to have a clear sight of the diagram. 
Drag and drop the file on the website of the [`Draw.io`](https://app.diagrams.net/).
![App architecture diagram](https://github.com/h88377/JKOAssignment/assets/66559497/1dae2d9a-9a34-4981-a061-23467bcf44a0)

## Design decision
* Implemented modular system by respecting S.O.L.I.D. principle to create `Item`, `Order`, `CoreData` and `Shared` layer and composing them in `Composition` layer. There are sublayers in the `Item` and `Order`, including `Feature (business logic)`, `Local`, `UI` and `Stub`. With such clear separation, they can be separated into different modules if needed.

#### Item layer
* Includes `商品列表` (includes pagination), `商品詳情` and `購物車` scenes.

#### Order layer
* Includes `確認訂單` and `歷史訂單紀錄` (includes pagination) scenes.

#### CoreData layer
* Acted as an adapter between `CoreData` framework and `Local` sublayer of `Item` and `Order` by implementing `Local-specific abstraction`.

#### Shared layer
* Shared UI components and helpers between `Item` and `Order`.

#### Composite layer
* Acted as all layers' client to initialize all components this application needs.
* Also decorated components differently based on the requirements.

#### Feature sublayer (Business logic)
* Defined feature abstraction components instead of concrete types. This way, the system can be more flexible when facing requirements changes by creating different implementations of the abstraction and composing them differently without altering the existed components.  
* Also, other sublayers are able to be developed in parallel by following the defined abstraction.

#### UI sublayer (Includes Presentation layer)
* Implemented MVVM as UI architecture to separate iOS-specific components (import UIKit) from feature logic (platform-agnostic) by using platform-agnostic presentation components (ViewModel). This way, the ViewModel can be reused across platforms if needed.
* Used closure as binding strategy to achieve simplest way of binding. 
* Implemented multiple MVVMs in one scene to avoid components holding too many responsibilities (massive view controller).
* Used `Composer` to reduce the complexity of creating a scene with multiple MVVMs from clients point of view.
* Decoupled UIViewControllers by using closure callback to send UIViewController navigation events to its client intead of creating another UIViewController within an UIViewController.

#### Local sublayer
* Hid the frameworks' details by depending on a local-specific abstraction (invert the dependency). This way, I can easily switch the frameworks based on the needs without altering current system.
* Separated the frameworks' details from business logic also make the framework components easy to test, develop and maintain since it just obeys the command.
* Created local-specific models to decouple `CoreData` sublayer from `Feature` sublayer and other components in `Local` sublayer.

#### Stub sublayer
* Only for this assignment-specific case. Normally it would be a `API` sublayer and applied the same concept in the `Local` sublayer.

## Design pattern

#### Decorator
* Dispatched the UI-specific results from background queue to main queue by `MainThreadDispatchDecorator` to eliminate duplicate code in UI layer.
* Decoupled `Order` from `Item` layer by using `OrderSaverWithCartDeleterDecorator` for cart deletion after completing the checkout process.
#### Adapter
* Decoupled `Local` sublayer from `CoreData` by using `CoreDataStore`.
#### Null Object
* Instead of making the application crash when the creation of CoreData stack failed, used `NullStore` to provide empty implementation.

## Requirements
> Xcode 13 or later  
> iOS 15.0 or later  
> Swift 5 or later

## Contact
Wayne Cheng｜h88377@gmail.com   

## Licence
JKOAssignment is released under the MIT license.
