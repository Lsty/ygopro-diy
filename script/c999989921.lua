--传说之狂战士 弗兰肯斯坦
function c999989921.initial_effect(c)
	c:SetUniqueOnField(1,0,999989921)
	aux.AddFusionProcFun2(c,c999989921.ffilter,c999989921.ffilter2,false)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c999989921.splimit)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c999989921.con)
	e2:SetTarget(c999989921.tg)
	e2:SetOperation(c999989921.op)
	c:RegisterEffect(e2)
	--[[Add counter1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c999989921.cop1)
	c:RegisterEffect(e3)
	--Add counter2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_DESTROY)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c999989921.cop2)
	c:RegisterEffect(e4)--]]
	--attack cost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ATTACK_COST)
	e5:SetCost(c999989921.atcost)
	e5:SetOperation(c999989921.atop)
	c:RegisterEffect(e5)
	--must attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_EP)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetTargetRange(1,0)
	e8:SetCondition(c999989921.becon)
	c:RegisterEffect(e8)
	--special summon rule
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(27346636,1))
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SPSUMMON_PROC)
	e9:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_EXTRA)
	e9:SetCondition(c999989921.sprcon)
	e9:SetOperation(c999989921.sprop)
	c:RegisterEffect(e9)
	--disable
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e10:SetCode(EFFECT_DISABLE)
	e10:SetCondition(c999989921.discon)
	e10:SetTarget(c999989921.distg)
	c:RegisterEffect(e10) 
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EVENT_CHAIN_ACTIVATING)
	e11:SetCondition(c999989921.discon)
	e11:SetOperation(c999989921.disop)
	c:RegisterEffect(e11)
	--atk
	local e12=Effect.CreateEffect(c)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_UPDATE_ATTACK)
	e12:SetRange(LOCATION_MZONE)
	e12:SetValue(c999989921.atkval)
	c:RegisterEffect(e12)
end
function c999989921.ffilter(c)
	return  c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_DARK) 
end
function c999989921.ffilter2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c999989921.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c999989921.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c999989921.filter(c)
	local code=c:GetCode()
	return (code==999989920)
end
function c999989921.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999989921.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999989921.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c999989921.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(999997,5))) then
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			Duel.Equip(tp,tc,c)
		else
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
end
end
--[[function c999989921.cop1(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) then
		e:GetHandler():AddCounter(0x1113,1)
	end
end
function c999989921.cfilter(c,e)
	return c:IsOnField() and c:IsReason(REASON_BATTLE) and c~=e:GetHandler()
end
function c999989921.cop2(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c999989921.cfilter,1,nil,e) then
	e:GetHandler():AddCounter(0x1113,1)
end
end--]]
function c999989921.atcost(e,c,tp)
	return Duel.IsCanRemoveCounter(tp,1,0,0x1113,1,REASON_COST) 
end
function c999989921.atop(e,tp,eg,ep,ev,re,r,rp)
		Duel.RemoveCounter(tp,1,0,0x1113,1,REASON_COST)
end
function c999989921.becon(e)
	return e:GetHandler():IsAttackable()
end
function c999989921.spfilter1(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(true)
		and Duel.IsExistingMatchingCard(c999989921.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c999989921.spfilter2(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c999989921.spfilter3(c)
	return c:IsType(TYPE_EQUIP)  and c:IsType(TYPE_SPELL)  and c:IsAbleToGraveAsCost()
end
function c999989921.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c999989921.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c999989921.spfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
end
function c999989921.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c999989921.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local g2=Duel.SelectMatchingCard(tp,c999989921.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	local g3=Duel.SelectMatchingCard(tp,c999989921.spfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(g1,REASON_COST)
end
function c999989921.discon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return   ph>=PHASE_BATTLE and ph<=PHASE_DAMAGE_CAL and Duel.GetCounter(e:GetHandlerPlayer(),LOCATION_ONFIELD,0,0x1113)>0 
end
function c999989921.distg(e,c)
	return  c~=e:GetHandler()
end
function c999989921.disop(e,tp,eg,ep,ev,re,r,rp)
if re:IsActiveType(TYPE_MONSTER) then
	Duel.NegateEffect(ev)
	end
end
function c999989921.atkval(e,c)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0x1113)*200
end
