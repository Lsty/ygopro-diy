--传说之暗杀者 李书文
function c999989931.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c999989931.xyzfilter),4,2)
	c:EnableReviveLimit()
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c999989931.tgcon)
	e1:SetValue(c999989931.tgvalue)
	c:RegisterEffect(e1)
	--[[local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	c:RegisterEffect(e2)--]]
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c999989931.atcon)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--actlimit
    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c999989931.aclimit)
	e4:SetCondition(c999989931.actcon2)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(999998,7))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_START)
	e5:SetCountLimit(1)
	e5:SetCost(c999989931.cost)
	e5:SetTarget(c999989931.destg)
	e5:SetOperation(c999989931.desop)
	c:RegisterEffect(e5)
	--must attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MUST_ATTACK)
	e6:SetCondition(c999989931.becon)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_EP)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,0)
	e7:SetCondition(c999989931.becon)
	c:RegisterEffect(e7)	
end
function c999989931.xyzfilter(c)
	return  c:IsSetCard(0x984) or c:IsSetCard(0x985)
end
function c999989931.tgcon(e)
	return e:GetHandler():GetOverlayCount()~=0 and Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c999989931.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c999989931.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c999989931.actcon2(e)
	return Duel.GetAttacker()==e:GetHandler()   and  e:GetHandler():GetOverlayCount()~=0
end
function c999989931.atcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and e:GetHandler()==Duel.GetAttacker() and  e:GetHandler():GetOverlayCount()==0
end
function c999989931.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end	
function c999989931.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc  end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c999989931.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Destroy(tc,REASON_EFFECT) end
end
function c999989931.becon(e)
return e:GetHandler():IsAttackable() and e:GetHandler():GetOverlayCount()==0
end