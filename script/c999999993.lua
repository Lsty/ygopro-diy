--±¶æﬂ Õª¥©À¿œË÷Æ«π
function c999999993.initial_effect(c)
	c:SetUniqueOnField(1,0,999999993)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,6))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c999999993.target)
	e1:SetOperation(c999999993.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c999999993.eqlimit)
	c:RegisterEffect(e2)
	--Atk£¨def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(400)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	e4:SetValue(400)
	c:RegisterEffect(e4)
	--[[search card
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(999999,7))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCost(c999999993.secost)
	e5:SetTarget(c999999993.setarget)
	e5:SetOperation(c999999993.seoperation)
	c:RegisterEffect(e5)--]]
    --destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(64332231,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c999999993.descon)
	e6:SetCost(c999999993.descost)
	e6:SetTarget(c999999993.destg)
	e6:SetOperation(c999999993.desop)
	c:RegisterEffect(e6)
end
function c999999993.eqlimit(e,c)
	return   c:IsCode(999989946) or c:IsCode(999999986) or c:IsCode(999999971)  or  c:IsCode(999999987)
end
function c999999993.filter(c)
	return c:IsFaceup() and   c:IsCode(999989946) or c:IsCode(999999986) or c:IsCode(999999971)  or  c:IsCode(999999987)
end
function c999999993.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c999999993.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999999993.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c999999993.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c999999993.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
--[[function c999999993.secost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() and Duel.GetFlagEffect(tp,999999993)==0 and Duel.GetFlagEffect(tp,999999946)==0 end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
    Duel.RegisterFlagEffect(tp,999999993,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,999999946,RESET_PHASE+PHASE_END,0,1)
end
function c999999993.sefilter(c)
	return c:GetCode()==999999946 and c:IsAbleToHand()
end
function c999999993.setarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999993.sefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999999993.seoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.SelectMatchingCard(tp,c999999993.sefilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end--]]
function c999999993.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c999999993.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c999999993.dfilter(c,def)
local d=def/2
	return c:IsFaceup()  and c:IsDestructable() and c:IsDefenceBelow(d)
end
function c999999993.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler()
	local tc=g:GetEquipTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(c999999993.dfilter,tp,0,LOCATION_MZONE,1,nil,tc:GetDefence()) end
	local sg=Duel.GetMatchingGroup(c999999993.dfilter,tp,0,LOCATION_MZONE,nil,tc:GetDefence())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,nil)
end
function c999999993.desop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=e:GetHandler()
	local tc=g:GetEquipTarget()
	if tc:IsFaceup()  then
		local sg1=Duel.GetMatchingGroup(c999999993.dfilter,tp,0,LOCATION_MZONE,nil,tc:GetDefence())
		local sg2=Duel.Destroy(sg1,REASON_EFFECT)
		Duel.Damage(1-tp,sg2*300,REASON_EFFECT)
end
end