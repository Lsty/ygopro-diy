--克洛斯贝尔-「西大街」
function c20111032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x929))
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetCode(EVENT_RELEASE)
	e3:SetTarget(c20111032.target)
	e3:SetOperation(c20111032.activate)
	c:RegisterEffect(e3)
	--summon proc
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20111032,0))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x929))
	e4:SetCondition(c20111032.sumcon)
	e4:SetOperation(c20111032.sumop)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e5)
end
function c20111032.filter(c)
	local tpe=c:GetType()
	return c:IsFaceup() and c:IsSetCard(0x929)
end
function c20111032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20111032.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c20111032.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c20111032.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_UPDATE_ATTACK)
		e6:SetValue(600)
		if Duel.GetTurnPlayer()==tp then
			e6:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
		else
			e6:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		end
		tc:RegisterEffect(e6)
		local e7=e6:Clone()
		e7:SetCode(EFFECT_UPDATE_DEFENCE)
		tc:RegisterEffect(e7)
		tc=g:GetNext()
	end
end
function c20111032.sumcon(e,c)
	if c==nil then return e:GetHandler():IsReleasable() end
	local mi,ma=c:GetTributeRequirement()
	return ma>0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c20111032.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Release(e:GetHandler(),REASON_COST)
end
