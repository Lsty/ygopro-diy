--Ê¹Í½ÉÙÅ®£­Ñýºü
function c187187018.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,187187005,aux.FilterBoolFunction(Card.IsSetCard,0x3abb),1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c187187018.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c187187018.sprcon)
	e2:SetOperation(c187187018.sprop)
	c:RegisterEffect(e2)
	--discard
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c187187018.target)
	e3:SetOperation(c187187018.operation)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c187187018.spcost)
	e4:SetTarget(c187187018.sptg)
	e4:SetOperation(c187187018.spop)
	c:RegisterEffect(e4)
end
function c187187018.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c187187018.spfilter1(c,tp)
	return c:IsCode(187187005) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(c187187018.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c187187018.spfilter2(c)
	local tpe=c:GetOriginalType()
	return c:IsCanBeFusionMaterial() and c:IsSetCard(0x3abb) and 
		((bit.band(tpe,TYPE_FUSION)>0 and c:IsAbleToGraveAsCost()) or 
		(bit.band(tpe,TYPE_FUSION)==0 and c:IsAbleToGraveAsCost()))
end
function c187187018.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c187187018.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp)
end
function c187187018.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c187187018.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	local g2=Duel.SelectMatchingCard(tp,c187187018.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(g1,nil,2,REASON_COST)
end
function c187187018.cfilter(c)
	return c:IsLevelAbove(1) and c:IsAbleToGraveAsCost() and c:IsSetCard(0x3abb)
end
function c187187018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
end
function c187187018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c187187018.operation(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return Duel.IsExistingMatchingCard(c187187018.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c187187018.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT,nil)
end
function c187187018.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,0,REASON_COST)
end
function c187187018.filter(c,e,tp)
	return c:IsSetCard(0x3abb) and c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,203,tp,false,false)
end
function c187187018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c187187018.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c187187018.spop(e,tp,eg,ep,ev,re,r,rp)
	local zc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if zc==0 then return end
	if not Duel.IsExistingMatchingCard(c187187018.filter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c187187018.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if zc==1 then
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		g:RemoveCard(sc)
		Duel.SpecialSummon(sc,203,tp,tp,false,false,POS_FACEUP)
		sc:RegisterFlagEffect(sc:GetOriginalCode(),RESET_EVENT+0x1ff0000,0,0)
		Duel.Destroy(g,REASON_EFFECT)
	else
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,203,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+0x1ff0000,0,0)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
