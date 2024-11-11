---
created: 2023-11-03T22:29
updated: 2023-11-03T22:29
---
## 大量v-if的弊端

> 在实际项目中，通常会遇到存在大量的业务条件选择的场景，这种情况下如果使用大量的"v-if"和"v-else"指令，会造成
> 
> 1、页面渲染性能下降，加载时间增加： 每个`v-if` 都需要遍历并计算这些条件，尤其是在条件选择复杂且计算开销较大时，会导致初始渲染的耗时增加，从而延长页面的加载时间。
> 
> 2、冗余代码增加：过多的`v-if` 会导致模板代码变得冗长和难以维护。导致代码可读性降低，难以理解和调试。
> 
> 3、可维护下降：当模板中存在大量的`v-if`时，由于每个条件判断都是独立的，修改其中一个条件可能需要修改多个地方，增加了出错的可能性，并使维护变得复杂。
> 
> 4、内存增加： 每个`v-if`条件都会生成对应的DOM元素，并在切换条件时进行创建和销毁，当模板中存在大量的`v-if`时，会导致内存占用增加，对性能和资源消耗产生影响。

## 可选的优化方案

### 利用计算属性

将复杂的条件逻辑转移到计算属性中处理，避免在template模板中频繁使用"v-if"和"v-else"。通过计算属性的返回值来控制渲染的内容, 这样使得template代码更简洁，条件处理的逻辑更清晰且更易维护。

``` html  
<template> 
    <div> 
        <span v-if="displayText">{{ displayText }}</span> 
    </div> 
 </template> 
 <script> 
     export default { 
         data() { 
             return { 
                 // ... 
              }; 
         }, 
         computed: { 
             displayText() { 
                 // 在此处添加复杂的条件逻辑 
                     if (/* condition */) { 
                        return 'Text 1'; 
                      } else if (/* another condition */) { 
                        return 'Text 2'; 
                      } else { 
                        return 'Default Text'; 
                       } 
               }, 
         },
     }; 
 </script>
```

### 使用异步动态组件（Dynamic components)

如果根据条件渲染不同的组件，可以使用 `<component :is="currentComponent">` 动态切换组件。

这种优化方式结合了`工厂模式`的使用，在工厂组件中注册所有的component组件，根据传入的 condition 知道具体生产哪个component，并使用 :is 进行页面渲染。

```html
<template> 
    <div> 
        <component :is="currentComponent"></component> 
    </div> 
</template> 
<script> 
    import ComponentA from './ComponentA.vue'; 
    import ComponentB from './ComponentB.vue'; 
    import ComponentC from './ComponentC.vue'; 
    export default { 
        data() { 
            return { 
                // ... 
             }; 
         }, 
         computed: { 
             currentComponent() { 
                // 在此处添加复杂的条件逻辑 
                if (/* condition */) { 
                     return ComponentA; 
                 } else if (/* another condition */) { 
                     return ComponentB; 
                 } else { 
                     return ComponentC; 
                 } 
             }, 
        }, 
        components: { 
            ComponentA, 
            ComponentB, 
            ComponentC, 
         }, 
    }; 
  </script>
``` 


### 使用v-show代替v-if

当需要频繁切换元素的显示和隐藏时，可以使用`v-show`替代`v-if`。因为`v-show`仅会改变元素的 CSS `display`属性，避免了DOM元素频繁切换显示和隐藏，而`v-if`会将元素从 DOM 中完全移除或重新插入，但是`v-show`不支持`<template>`元素和`v-else`。

```html
<template>
    <div> 
        <span v-show="isVisible">显示文本</span> 
    </div> 
</template> 
<script> 
    export default { 
        data() { 
            return { 
                isVisible: true, 
             }; 
         }, 
    }; 
</script>
```

### 将条件逻辑移入子组件

将条件逻辑分解到更小的子组件中可以使得代码更加模块化和可维护。每个子组件可以负责处理自己的条件逻辑，从而降低父组件的复杂性。

```html
<!-- ParentComponent.vue --> 
<template> 
    <div> 
        <child-component :data="data"></child-component> 
    </div> 
</template> 
<script> 
    import ChildComponent from './ChildComponent.vue'; 
    export default { 
        components: { 
            ChildComponent, 
        }, 
        data() { 
            return { 
                data: /* some data */, 
             }; 
         }, 
    }; 
</script>   
<!-- ChildComponent.vue --> 
<template> 
    <div> 
        <span v-if="condition1">Text 1</span> 
        <span v-else-if="condition2">Text 2</span> 
        <span v-else>Default Text</span> 
    </div> 
</template> 
<script> 
    export default { 
        props: ['data'], 
        computed: { 
            condition1() { 
                // Calculate condition1 based on this.data 
            }, 
            condition2() { 
                // Calculate condition2 based on this.data 
            }, 
        }, 
    }; 
</script>
```

### 数据预处理

如果某些条件在渲染过程中保持不变，可以在数据层面进行预处理，并将结果缓存起来。这样可以避免在模板中重复计算和判断条件。

```html
<template>
  <div>
    <template v-if="isConditionA">
      <!-- 渲染条件 A 的内容 -->
    </template>
    <template v-else-if="isConditionB">
      <!-- 渲染条件 B 的内容 -->
    </template>
    <template v-else>
      <!-- 渲染默认内容 -->
    </template>
  </div>
</template>

<script>
export default {
  data() {
    return {
      data: /* 原始数据 */,
      isConditionA: false,
      isConditionB: false
    };
  },
  created() {
    // 预处理数据，并计算条件结果
    // 可以在这里对 this.data 进行处理，然后计算出 this.isConditionA 和 this.isConditionB 的值
  }
}
</script>
```


参考链接
1. [如何优化Vue template 中的大量条件选择v-if - 掘金 (juejin.cn)](https://juejin.cn/post/7254559214588575802?utm_source=gold_browser_extension)