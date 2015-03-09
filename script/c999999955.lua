-- 宝具 轮转胜利之剑
function c999999955.initial_effect(c)
	c:SetUniqueOnField(1,0,999999955)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,6))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c999999955.target)
	e1:SetOperation(c999999955.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c999999955.eqlimit)
	c:RegisterEffect(e2)
	--ATK&DEF
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	e4:SetValue(500)
	c:RegisterEffect(e4)
	--[[ocal e5=Effect.CreateEffect(c)
	e5:SetCode(EVENT_DAMAGE_CALCULATING)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c999999955.atkop)
	c:RegisterEffect(e5)--]]
	--when went
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCountLimit(1,999999955+EFFECT_COUNT_CODE_OATH)
	e6:SetTarget(c999999955.wwtg)
	e6:SetOperation(c999999955.wwop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e7)
	--[[search card
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(999999,7))
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_HAND)
	e8:SetCost(c999999955.secost)
	e8:SetTarget(c999999955.setarget)
	e8:SetOperation(c999999955.seoperation)
	c:RegisterEffect(e8)--]]
	--cannot be destroyed
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_EQUIP)
	e9:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e9:SetValue(c999999955.valcon)
	e9:SetCountLimit(1)
	c:RegisterEffect(e9)
end
function c999999955.eqlimit(e,c)
	return c:IsCode(999999956) or c:IsCode(999999971)  or  c:IsCode(999999987)
end
function c999999955.filter(c)
	return c:IsFaceup() and c:IsCode(999999956) or c:IsCode(999999971)  or  c:IsCode(999999987)
end
function c999999955.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c999999955.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999999955.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c999999955.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c999999955.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
--[[function c999999955.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc==nil then return end
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+RESET_DAMAGE_CAL)
		e1:SetValue(500)
		c:RegisterEffect(e1)
end--]]
function c999999955.thfilter(c)
return (c:IsSetCard(0x984) or c:IsSetCard(0x985)) and c:IsAbleToDeck() and c:GetCode()~=999999955
end
function c999999955.wwtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c999999955.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c999999955.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c999999955.wwop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFirstTarget()
	if sg:IsRelateToEffect(e) then
	Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	end
	if e:GetHandler():IsRelateToEffect(e) then
	Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
end
--[[function c999999955.secost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() and Duel.GetFlagEffect(tp,999999955)==0 and
	Duel.GetFlagEffect(tp,999999956)==0 end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
    Duel.RegisterFlagEffect(tp,999999955,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,999999956,RESET_PHASE+PHASE_END,0,1)
end
function c999999955.sefilter(c)
	return c:GetCode()==999999956 and c:IsAbleToHand()
end
function c999999955.setarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999955.sefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999999955.seoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.SelectMatchingCard(tp,c999999955.sefilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
--]]
function c999999955.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end