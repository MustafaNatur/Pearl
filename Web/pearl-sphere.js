class PearlSphere {
    constructor(container, options = {}) {
        this.options = {
            size: options.size || 1,
            baseColor: options.baseColor || '#ffffff',
            accentColor: options.accentColor || '#ff7eb6',
            autoRotate: options.autoRotate !== undefined ? options.autoRotate : true,
            controlsEnabled: options.controlsEnabled !== undefined ? options.controlsEnabled : true,
            iridescence: options.iridescence || 0.5,
            gloss: options.gloss || 0.8,
            pearlShift: options.pearlShift || 0.3,
            animationSpeed: options.animationSpeed || 1.0,
            ...options
        };

        this.state = {
            isRotating: this.options.autoRotate,
            isAutoOrbiting: false,
            baseSpeed: this.options.animationSpeed,
            iridescence: this.options.iridescence,
            gloss: this.options.gloss,
            pearlShift: this.options.pearlShift,
            baseColor: new THREE.Color(this.options.baseColor),
            accentColor: new THREE.Color(this.options.accentColor)
        };

        this.container = container;
        this.init();
    }

    init() {
        // Scene setup
        this.scene = new THREE.Scene();
        
        // Camera setup
        this.camera = new THREE.PerspectiveCamera(75, this.container.clientWidth / this.container.clientHeight, 0.1, 1000);
        this.camera.position.z = 2.5;  // Moved camera closer to make sphere appear larger

        // Renderer setup
        this.renderer = new THREE.WebGLRenderer({ 
            antialias: true,
            alpha: true,
            powerPreference: "high-performance"
        });
        
        // Set renderer size to exactly match container
        this.renderer.setSize(100, 100, false);  // Force size to 100x100 pixels, false to avoid setting style
        this.renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
        
        // Set canvas style to fill container
        this.renderer.domElement.style.width = '100%';
        this.renderer.domElement.style.height = '100%';
        this.container.appendChild(this.renderer.domElement);

        if (this.options.controlsEnabled) {
            // Controls setup
            this.controls = new THREE.OrbitControls(this.camera, this.renderer.domElement);
            this.controls.enableDamping = true;
            this.controls.dampingFactor = 0.05;
            this.controls.maxDistance = 8;
            this.controls.minDistance = 1.5;
        }

        // Lighting
        const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
        this.scene.add(ambientLight);

        const frontLight = new THREE.DirectionalLight(0xffffff, 1);
        frontLight.position.set(2, 2, 2);
        this.scene.add(frontLight);

        const backLight = new THREE.DirectionalLight(0xffffff, 0.5);
        backLight.position.set(-2, -2, -2);
        this.scene.add(backLight);

        // Create pearl material
        this.pearlMaterial = new THREE.ShaderMaterial({
            uniforms: {
                time: { value: 0 },
                iridescence: { value: this.state.iridescence },
                gloss: { value: this.state.gloss },
                pearlShift: { value: this.state.pearlShift },
                baseColor: { value: this.state.baseColor },
                accentColor: { value: this.state.accentColor }
            },
            vertexShader: `
                varying vec3 vNormal;
                varying vec3 vPosition;
                varying vec2 vUv;
                
                void main() {
                    vNormal = normalize(normalMatrix * normal);
                    vPosition = position;
                    vUv = uv;
                    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
                }
            `,
            fragmentShader: `
                uniform float time;
                uniform float iridescence;
                uniform float gloss;
                uniform float pearlShift;
                uniform vec3 baseColor;
                uniform vec3 accentColor;
                varying vec3 vNormal;
                varying vec3 vPosition;
                varying vec2 vUv;

                void main() {
                    vec3 normal = normalize(vNormal);
                    vec3 viewDir = normalize(cameraPosition - vPosition);
                    
                    float fresnel = pow(1.0 - abs(dot(normal, viewDir)), 3.0);
                    
                    float pearl = sin(vPosition.x * 10.0 + vPosition.y * 10.0 + time) * 0.5 + 0.5;
                    pearl *= pearlShift;
                    
                    vec3 iridescentColor = vec3(
                        sin(pearl * 6.28 + time) * 0.5 + 0.5,
                        sin(pearl * 6.28 + time + 2.094) * 0.5 + 0.5,
                        sin(pearl * 6.28 + time + 4.188) * 0.5 + 0.5
                    );
                    
                    float gradient = sin(vUv.y * 3.14159 + time * 0.2) * 0.5 + 0.5;
                    
                    vec3 pearlColor = mix(baseColor, accentColor, gradient * 0.5);
                    vec3 finalColor = mix(pearlColor, iridescentColor, iridescence * fresnel);
                    
                    finalColor = mix(finalColor, vec3(1.0), fresnel * gloss);
                    
                    float innerGlow = (1.0 - fresnel) * 0.2;
                    finalColor += accentColor * innerGlow;
                    
                    gl_FragColor = vec4(finalColor, 1.0);
                }
            `
        });

        // Create sphere
        const sphereGeometry = new THREE.SphereGeometry(this.options.size, 128, 128);
        this.sphere = new THREE.Mesh(sphereGeometry, this.pearlMaterial);
        this.scene.add(this.sphere);

        // Start animation
        this.time = 0;
        this.animate();

        // Handle resize
        window.addEventListener('resize', this.handleResize.bind(this));
    }

    animate() {
        requestAnimationFrame(this.animate.bind(this));
        
        this.time += 0.02 * this.state.baseSpeed;  // Doubled base animation speed
        
        if (this.state.isRotating) {
            this.sphere.rotation.y += 0.006 * this.state.baseSpeed;  // Doubled rotation speed
            this.sphere.rotation.x = Math.sin(this.time * 0.8) * 0.1;  // Faster tilt animation
            // Removed vertical position animation
        }

        if (this.state.isAutoOrbiting) {
            this.camera.position.x = Math.cos(this.time * 0.2) * 3;
            this.camera.position.z = Math.sin(this.time * 0.2) * 3;
            this.camera.lookAt(this.scene.position);
        }
        
        this.pearlMaterial.uniforms.time.value = this.time;
        
        if (this.controls) {
            this.controls.update();
        }
        
        this.renderer.render(this.scene, this.camera);
    }

    handleResize() {
        // Always maintain 1:1 aspect ratio for the pearl
        this.camera.aspect = 1;
        this.camera.updateProjectionMatrix();
        this.renderer.setSize(100, 100, false);
    }

    // Public methods for controlling the sphere
    setRotation(enabled) {
        this.state.isRotating = enabled;
    }

    setAutoOrbit(enabled) {
        this.state.isAutoOrbiting = enabled;
    }

    setColors(baseColor, accentColor) {
        this.state.baseColor.set(baseColor);
        this.state.accentColor.set(accentColor);
        this.pearlMaterial.uniforms.baseColor.value = this.state.baseColor;
        this.pearlMaterial.uniforms.accentColor.value = this.state.accentColor;
    }

    setProperties(props) {
        if (props.iridescence !== undefined) {
            this.state.iridescence = props.iridescence;
            this.pearlMaterial.uniforms.iridescence.value = props.iridescence;
        }
        if (props.gloss !== undefined) {
            this.state.gloss = props.gloss;
            this.pearlMaterial.uniforms.gloss.value = props.gloss;
        }
        if (props.pearlShift !== undefined) {
            this.state.pearlShift = props.pearlShift;
            this.pearlMaterial.uniforms.pearlShift.value = props.pearlShift;
        }
        if (props.animationSpeed !== undefined) {
            this.state.baseSpeed = props.animationSpeed;
        }
    }

    dispose() {
        // Clean up resources
        this.pearlMaterial.dispose();
        this.sphere.geometry.dispose();
        this.renderer.dispose();
        window.removeEventListener('resize', this.handleResize.bind(this));
    }
}