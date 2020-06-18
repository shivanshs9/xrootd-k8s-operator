package objects

import (
	"github.com/shivanshs9/xrootd-operator/pkg/apis/xrootd/v1alpha1"
	"github.com/shivanshs9/xrootd-operator/pkg/utils/types"
	appsv1 "k8s.io/api/apps/v1"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

func GenerateXrootdStatefulSet(
	xrootd *v1alpha1.Xrootd, objectName types.ObjectName,
	compLabels types.Labels, componentName types.ComponentName,
) appsv1.StatefulSet {
	labels := compLabels
	name := string(objectName)
	var replicas int32 = xrootd.Spec.Redirector.Replicas
	containers, volumes := getXrootdContainersAndVolume(xrootd, componentName)
	return appsv1.StatefulSet{
		ObjectMeta: metav1.ObjectMeta{
			Name:      name,
			Namespace: xrootd.Namespace,
			Labels:    labels,
		},
		Spec: appsv1.StatefulSetSpec{
			Replicas: &replicas,
			Selector: &metav1.LabelSelector{
				MatchLabels: labels,
			},
			Template: v1.PodTemplateSpec{
				ObjectMeta: metav1.ObjectMeta{
					Labels: labels,
				},
				Spec: v1.PodSpec{
					Containers: containers,
					Volumes:    volumes.ToSlice(),
				},
			},
		},
	}
}