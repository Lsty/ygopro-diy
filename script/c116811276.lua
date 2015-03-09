--镜世录 亡我
function c116811276.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x3e2),3,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c116811276.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c116811276.sprcon)
	e2:SetOperation(c116811276.sprop)
	c:RegisterEffect(e2)
	--place
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(116811276,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c116811276.condition)
	e3:SetTarget(c116811276.target)
	e3:SetOperation(c116811276.operation)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c116811276.val)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e5)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetRange(LOCATION_ONFIELD)
	e6:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e6:SetTarget(c116811276.distg)
	c:RegisterEffect(e6)
	--disable effect
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAIN_SOLVING)
	e7:SetRange(LOCATION_ONFIELD)
	e7:SetOperation(c116811276.disop)
	c:RegisterEffect(e7)
	--disable trap monster
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e8:SetRange(LOCATION_ONFIELD)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetTarget(c116811276.distg)
	c:RegisterEffect(e8)
	--cannot trigger
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_TRIGGER)
	e9:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e9:SetRange(LOCATION_ONFIELD)
	e9:SetTargetRange(0xa,0xa)
	e9:SetTarget(c116811276.distg)
	c:RegisterEffect(e9)
end
function c116811276.distg(e,c)
	return c:IsType(TYPE_TRAP)
end
function c116811276.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_TRAP) then
		Duel.NegateEffect(ev)
	end
end
function c116811276.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)*200
end
function c116811276.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c116811276.spfilter1(c)
	return c:IsSetCard(0x3e2) 
end
function c116811276.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c116811276.spfilter1,tp,LOCATION_SZONE,0,3,nil,tp)
end
function c116811276.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(116811276,0))
	local g1=Duel.SelectMatchingCard(tp,c116811276.spfilter1,tp,LOCATION_SZONE,0,3,3,nil,tp)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(g1,REASON_COST)
end
function c116811276.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_EXTRA
end
function c116811276.efilter(c)
	return c:IsDefenceBelow(1450) and c:IsSetCard(0x3e2) and c:IsType(TYPE_MONSTER)
end
function c116811276.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c116811276.efilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c116811276.efilter,tp,LOCATION_GRAVE,0,1,nil) end
	local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	if ft>5 then ft=5 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c116811276.efilter,tp,LOCATION_GRAVE,0,1,ft,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,5,0,0)
end
function c116811276.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		if sg:GetCount()>ft then
			local rg=sg:Select(tp,ft,ft,nil)
			sg=rg
		end
		local tc=sg:GetFirst()
		while tc do
			Duel.MoveToField(tc,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			tc=sg:GetNext()
		end
	end
end