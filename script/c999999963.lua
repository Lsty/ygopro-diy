--乖离剑·Ea
function c999999963.initial_effect(c)
	c:SetUniqueOnField(1,0,999999963)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999999,6))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c999999963.target)
	e1:SetOperation(c999999963.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c999999963.eqlimit)
	c:RegisterEffect(e2)
	--Atk，def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	e4:SetValue(1000)
	c:RegisterEffect(e4)
	--[[search card
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(999999,7))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCost(c999999963.secost)
	e5:SetTarget(c999999963.setarget)
	e5:SetOperation(c999999963.seoperation)
	c:RegisterEffect(e5)--]]
    --destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(999998,5))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCost(c999999963.descost)
    e6:SetTarget(c999999963.destg)
	e6:SetOperation(c999999963.desop)
	c:RegisterEffect(e6)
		if not c999999963.global_check then
		c999999963.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c999999963.checkop)
		Duel.RegisterEffect(ge1,0)
	end
    --negate
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_CHAINING)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c999999963.negcon)
	e7:SetTarget(c999999963.negtg)
	e7:SetOperation(c999999963.negop)
	c:RegisterEffect(e7)
	--Untargetable
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_EQUIP)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetValue(c999999963.tglimit)
	c:RegisterEffect(e8)
end
function c999999963.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsCode(999999963) then
		Duel.RegisterFlagEffect(rp,999999963,RESET_PHASE+PHASE_END,0,1)
	end
end
function c999999963.eqlimit(e,c)
	return  c:IsCode(999999997) or c:IsCode(999989932) 
end
function c999999963.filter(c)
	return c:IsFaceup() and c:IsCode(999999997) or c:IsCode(999989932) 
end
function c999999963.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c999999963.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999999963.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c999999963.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c999999963.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
--[[function c999999963.secost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() and Duel.GetFlagEffect(tp,999999963)==0 end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
    Duel.RegisterFlagEffect(tp,999999963,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,999999932,RESET_PHASE+PHASE_END,0,1)
end
function c999999963.sefilter(c)
	return c:GetCode()==999999932 and c:IsAbleToHand()
end
function c999999963.setarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999963.sefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c999999963.seoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.SelectMatchingCard(tp,c999999963.sefilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end--]]
function c999999963.hfilter(c)
	return c:IsDiscardable() 
end
function c999999963.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999963.hfilter,tp,LOCATION_HAND,0,1,nil)
    and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 and Duel.GetCurrentPhase()~=PHASE_MAIN2 and Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0	and Duel.GetFlagEffect(tp,999999963)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BP)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetValue(c999999963.aclimit)
	Duel.RegisterEffect(e4,tp)
end
function c999999963.aclimit(e,re,tp)
	return not re:GetHandler():IsCode(999999963)
end
function c999999963.desfilter(c)
	return  c:IsDestructable ()
end
function c999999963.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999963.desfilter,tp,0,LOCATION_ONFIELD,1,nil)   end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.GetMatchingGroup(c999999963.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c999999963.desop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local g=Duel.GetMatchingGroup(c999999963.desfilter,tp,0,LOCATION_ONFIELD,nil)
   Duel.Destroy(g,REASON_EFFECT)
end
function c999999963.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_SZONE
		and re:IsActiveType(TYPE_CONTINUOUS+TYPE_FIELD) and Duel.IsChainDisablable(ev) 
end
function c999999963.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c999999963.negop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) then
	Duel.Destroy(eg,REASON_EFFECT)
end
end
function c999999963.tglimit(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end