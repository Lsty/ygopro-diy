--��ߡ�йʸ�����֡�
function c329408.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c329408.target)
	e1:SetOperation(c329408.operation)
	c:RegisterEffect(e1)
	--Untargetable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c329408.eqlimit)
	c:RegisterEffect(e3)
	--Atk,def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(500)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_DEFENCE)
	e5:SetValue(500)
	c:RegisterEffect(e5)
	--when went
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCountLimit(1,329408+EFFECT_COUNT_CODE_OATH)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetTarget(c329408.wwtg)
	e6:SetOperation(c329408.wwop)
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
	e8:SetCost(c329408.secost)
	e8:SetTarget(c329408.setarget)
	e8:SetOperation(c329408.seoperation)
	c:RegisterEffect(e8)--]]
	--immune
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCode(EFFECT_IMMUNE_EFFECT)
	e9:SetValue(c329408.imfilter)
	c:RegisterEffect(e9)
end
function c329408.eqlimit(e,c)
	return c:IsSetCard(0x301)
end
function c329408.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x301)
end
function c329408.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c329408.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c329408.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c329408.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c329408.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c329408.thfilter(c)
	return   (c:IsSetCard(0x301)) and c:IsAbleToDeck() and c:GetCode()~=329408
end
function c329408.wwtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c329408.thfilter,tp,LOCATION_GRAVE,0,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c329408.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c329408.wwop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFirstTarget()
	if sg:IsRelateToEffect(e) then
	Duel.SendtoHand(sg,nil,1,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	end
	if e:GetHandler():IsRelateToEffect(e) then
	Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
end
end
--[[function c329408.secost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() and Duel.GetFlagEffect(tp,329408)==0 and
	Duel.GetFlagEffect(tp,329408)==0 end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	Duel.RegisterFlagEffect(tp,c:IsSetCard(0x301),RESET_PHASE+PHASE_END,0,1)
end
function c329408.sefilter(c)
	return c:GetCode()==999999992 and c:IsAbleToHand()
end
function c329408.setarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c329408.sefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c329408.seoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.SelectMatchingCard(tp,c329408.sefilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end--]]