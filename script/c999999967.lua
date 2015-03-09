--宝具 刺穿死棘之枪
function c999999967.initial_effect(c)
	c:SetUniqueOnField(1,0,999999967)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,6))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c999999967.target)
	e1:SetOperation(c999999967.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c999999967.eqlimit)
	c:RegisterEffect(e2)
	--Atk/def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(600)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	e4:SetValue(600)
	c:RegisterEffect(e4)
	--[[search card
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(999999,7))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCost(c999999967.secost)
	e5:SetTarget(c999999967.setarget)
	e5:SetOperation(c999999967.seoperation)
	c:RegisterEffect(e5)--]]
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(999999,11))
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCost(c999999967.sgcost)
	e6:SetTarget(c999999967.sgtg)
	e6:SetOperation(c999999967.sgop)
	c:RegisterEffect(e6)
end
function c999999967.eqlimit(e,c)
	return  c:IsCode(999989946) or c:IsCode(999999986) or c:IsCode(999999971)  or  c:IsCode(999999987)
end
function c999999967.filter(c)
	return c:IsFaceup() and  c:IsCode(999989946) or c:IsCode(999999986) or c:IsCode(999999971)  or  c:IsCode(999999987)
end
function c999999967.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c999999967.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999999967.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c999999967.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c999999967.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
--[[function c999999967.secost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() and Duel.GetFlagEffect(tp,999999967)==0 and  Duel.GetFlagEffect(tp,999999946)==0 end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
    Duel.RegisterFlagEffect(tp,999999967,RESET_PHASE+PHASE_END,0,1)
    Duel.RegisterFlagEffect(tp,999999946,RESET_PHASE+PHASE_END,0,1)
end
function c999999967.sefilter(c)
	return c:GetCode()==999999946 and c:IsAbleToHand()
end
function c999999967.setarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999967.sefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999999967.seoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.SelectMatchingCard(tp,c999999967.sefilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end--]]
function c999999967.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetEquipTarget()
	if chk==0 then return g:GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	g:RegisterEffect(e1)
end
function c999999967.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c999999967.sgop(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
	  local atk=g:GetFirst():GetAttack()/2
		Duel.HintSelection(g)
		if atk>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end   
    end
end

