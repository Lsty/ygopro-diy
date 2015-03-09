--±¦¾ß ÆÆÄ§µÄºìÇ¾Þ±
function c999999974.initial_effect(c)
	c:SetUniqueOnField(1,0,999999974)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,6))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c999999974.target)
	e1:SetOperation(c999999974.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c999999974.eqlimit)
	c:RegisterEffect(e2)
	--Atk£¬def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	e4:SetValue(800)
	c:RegisterEffect(e4)
	--[[--search card
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(999999,7))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCost(c999999974.secost)
	e5:SetTarget(c999999974.setarget)
	e5:SetOperation(c999999974.seoperation)
	c:RegisterEffect(e5)--]]
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c999999974.imcon)
	e6:SetOperation(c999999974.imop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(c999999974.imcon)
	e7:SetOperation(c999999974.imop2)
	c:RegisterEffect(e7)	
end
function c999999974.eqlimit(e,c)
	return  c:IsCode(999999983) or c:IsCode(999989949) or c:IsCode(999999971)  or  c:IsCode(999999987)
end
function c999999974.filter(c)
	return c:IsFaceup() and c:IsCode(999999983) or c:IsCode(999989949) or c:IsCode(999999971)  or  c:IsCode(999999987)
end
function c999999974.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c999999974.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999999974.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c999999974.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c999999974.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
--[[function c999999974.secost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() and Duel.GetFlagEffect(tp,999999974)==0  and Duel.GetFlagEffect(tp,999999983)==0  end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
    Duel.RegisterFlagEffect(tp,999999974,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,999999983,RESET_PHASE+PHASE_END,0,1)
end
function c999999974.sefilter(c)
	return c:GetCode()==999999983 and c:IsAbleToHand()
end
function c999999974.setarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999974.sefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999999974.seoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.SelectMatchingCard(tp,c999999974.sefilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end--]]
function c999999974.imcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget():GetBattleTarget()~=nil
end
function c999999974.imop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetEquipTarget():GetBattleTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c999999974.efilter)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	bc:RegisterEffect(e1,true)
end
function c999999974.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)  and te:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function c999999974.imop2(e,tp,eg,ep,ev,re,r,rp)
	local bb=e:GetHandler():GetEquipTarget():GetBattleTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c999999974.efilter)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	bb:RegisterEffect(e1,true)
end
