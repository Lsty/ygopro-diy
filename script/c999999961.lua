--传说之暗杀者 开膛手 杰克
function c999999961.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c999999961.xyzfilter),3,2,nil,nil,5)
	c:EnableReviveLimit()
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c999999961.tgcon)
	e1:SetValue(c999999961.tgvalue)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetCondition(c999999961.tgcon2)
	c:RegisterEffect(e2)
	--actlimit
	 local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c999999961.aclimit)
	e4:SetCondition(c999999961.actcon)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c999999961.scon)
	e5:SetTarget(c999999961.stg)
	e5:SetOperation(c999999961.sop)
	c:RegisterEffect(e5)
	--atk up
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(999999,10))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c999999961.cost)
	e6:SetOperation(c999999961.operation)
	c:RegisterEffect(e6)
	 --must attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_MUST_ATTACK)
	e7:SetCondition(c999999961.becon)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_EP)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetTargetRange(1,0)
	e8:SetCondition(c999999961.becon)
	c:RegisterEffect(e8)
end
function c999999961.xyzfilter(c)
	return  c:IsSetCard(0x984) or c:IsSetCard(0x985)
end
function c999999961.tgcon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c999999961.tgcon2(e)
	return e:GetHandler():GetOverlayCount()~=0 and Duel.IsExistingMatchingCard(c999999961.sfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil) 
end
function c999999961.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c999999961.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c999999961.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() 
end
function c999999961.scon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c999999961.sfilter(c)
	local code=c:GetCode()
	return (code==999999960) and c:IsAbleToHand()   
end
function c999999961.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999961.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999999961.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999999961.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c999999961.cost(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local t=c:GetOverlayCount()
	e:SetLabel(t)
	e:GetHandler():RemoveOverlayCard(tp,t,t,REASON_COST)
	end
 function c999999961.operation(e,tp,eg,ep,ev,re,r,rp,chk)
 local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
     local atk=e:GetLabel(t)
 	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(atk*500)
		c:RegisterEffect(e1)
end
end
function c999999961.becon(e)
return e:GetHandler():IsAttackable() and e:GetHandler():GetOverlayCount()==0
end