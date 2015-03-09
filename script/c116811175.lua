--黑之萃梦想
function c116811175.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c116811175.synfilter,aux.NonTuner(c116811175.synfilter),1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(116811175,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCountLimit(1,116811175)
	e1:SetCondition(c116811175.condition)
	e1:SetTarget(c116811175.target)
	e1:SetOperation(c116811175.operation)
	c:RegisterEffect(e1)
	--multiattack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(c116811175.val)
	c:RegisterEffect(e2)
	--atklimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e5)
end
function c116811175.afilter(c)
	return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c116811175.val(e,c)
	return Duel.GetMatchingGroupCount(c116811175.afilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil)
end
function c116811175.synfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c116811175.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a~=c then d=a end
	return c:IsRelateToBattle() and c:IsFaceup()
		and d and d:GetLocation()==LOCATION_GRAVE and d:IsType(TYPE_MONSTER)
end
function c116811175.efilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c116811175.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c116811175.efilter,tp,0,LOCATION_GRAVE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c116811175.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c116811175.efilter,tp,0,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end