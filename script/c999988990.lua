--传说之骑士 贞德 
function c999988990.initial_effect(c)
	aux.AddFusionProcFun2(c,c999988990.ffilter,c999988990.ffilter2,false)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c999988990.splimit)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c999988990.con)
	e2:SetTarget(c999988990.tg)
	e2:SetOperation(c999988990.op)
	c:RegisterEffect(e2)
	--special summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27346636,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c999988990.sprcon)
	e3:SetOperation(c999988990.sprop)
	c:RegisterEffect(e3)
	--immune spell
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c999988990.efilter)
	c:RegisterEffect(e4)
	--红莲の圣女
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(88177324,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(TIMING_BATTLE_START,0)
	e5:SetCountLimit(1,999988990)
	e5:SetCondition(c999988990.bncon)
	e5:SetCost(c999988990.bncost)
	e5:SetTarget(c999988990.bntg)
	e5:SetOperation(c999988990.bnop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetDescription(aux.Stringid(40921744,2))
  	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e6:SetCountLimit(1)
	e6:SetCondition(c999988990.sgcon)
	e6:SetTarget(c999988990.sgtg)
	e6:SetOperation(c999988990.sgop)
	c:RegisterEffect(e6)
	--[[--add code
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_ADD_CODE)
	e7:SetValue(999988992)
	c:RegisterEffect(e7)--]]
	--confirm
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(88069166,0))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetOperation(c999988990.cop)
	c:RegisterEffect(e8)
end
function c999988990.ffilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c999988990.ffilter2(c)
	return  c:IsRace(RACE_WARRIOR)
end
function c999988990.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c999988990.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c999988990.filter(c)
	local code=c:GetCode()
	return (code==999988991)
end
function c999988990.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999988990.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999988990.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c999988990.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
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
function c999988990.spfilter1(c,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE)  and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(true)
	and Duel.IsExistingMatchingCard(c999988990.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c999988990.spfilter2(c)
	return c:IsRace(RACE_WARRIOR) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c999988990.spfilter3(c)
	return c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL)  and c:IsAbleToGraveAsCost() 
end
function c999988990.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c999988990.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c999988990.spfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
end
function c999988990.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c999988990.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local g2=Duel.SelectMatchingCard(tp,c999988990.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	local g3=Duel.SelectMatchingCard(tp,c999988990.spfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(g1,REASON_COST)
end
function c999988990.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c999988990.bncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE and not Duel.CheckPhaseActivity() and Duel.GetCurrentChain()==0
end
function c999988990.bncost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(999988990)==0 end
	e:GetHandler():RegisterFlagEffect(999988990,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c999988990.bnfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c999988990.bntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999988990.bnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local sg=Duel.GetMatchingGroup(c999988990.bnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,sg:GetCount()*800,0,tp,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,sg:GetCount()*800,0,1-tp,nil)
end
function c999988990.bnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c999988990.bnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	if ct>0 then
	Duel.Damage(tp,ct*800,REASON_EFFECT)
	Duel.Damage(1-tp,ct*800,REASON_EFFECT)
end
end
function c999988990.sgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(999988990)~=0
end
function c999988990.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c999988990.sgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
function c999988990.cop(e,tp,eg,ep,ev,re,r,rp)
		local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
		g1:Merge(g2)
		Duel.ConfirmCards(tp,g1)
		Duel.ShuffleHand(1-tp)
end