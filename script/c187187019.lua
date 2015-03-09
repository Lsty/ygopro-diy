--Ê¹Í½ÉÙÅ®£­ºÚÓð
function c187187019.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,187187036,aux.FilterBoolFunction(Card.IsSetCard,0x3abb),1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c187187019.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c187187019.sprcon)
	e2:SetOperation(c187187019.sprop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c187187019.target)
	e3:SetOperation(c187187019.operation)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c187187019.spcost)
	e4:SetTarget(c187187019.sptg)
	e4:SetOperation(c187187019.spop)
	c:RegisterEffect(e4)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,187187)
	e1:SetTarget(c187187019.eqtg)
	e1:SetOperation(c187187019.eqop)
	c:RegisterEffect(e1)
end
function c187187019.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3abb)
end
function c187187019.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c187187019.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c187187019.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c187187019.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,true) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c187187019.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c187187019.eqlimit(e,c)
	return e:GetOwner()==c
end
function c187187019.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c187187019.spfilter1(c,tp)
	return c:IsCode(187187036) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial() and c:IsSetCard(0x3abb)
		and Duel.IsExistingMatchingCard(c187187019.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c187187019.spfilter2(c)
	local tpe=c:GetOriginalType()
	return c:IsCanBeFusionMaterial() and c:IsSetCard(0x3abb) and 
		((bit.band(tpe,TYPE_FUSION)>0 and c:IsAbleToGraveAsCost()) or 
		(bit.band(tpe,TYPE_FUSION)==0 and c:IsAbleToGraveAsCost()))
end
function c187187019.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c187187019.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp)
end
function c187187019.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c187187019.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	local g2=Duel.SelectMatchingCard(tp,c187187019.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(g1,nil,2,REASON_COST)
end
function c187187019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_SZONE,LOCATION_SZONE,2,nil) end
	if Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_SZONE,LOCATION_SZONE,2,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_SZONE,LOCATION_SZONE,2,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	end
end
function c187187019.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c187187019.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,0,REASON_COST)
end
function c187187019.filter(c,e,tp)
	return c:IsSetCard(0x3abb) and c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,204,tp,false,false)
end
function c187187019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c187187019.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c187187019.spop(e,tp,eg,ep,ev,re,r,rp)
	local zc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if zc==0 then return end
	if not Duel.IsExistingMatchingCard(c187187019.filter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c187187019.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if zc==1 then
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		g:RemoveCard(sc)
		Duel.SpecialSummon(sc,204,tp,tp,false,false,POS_FACEUP)
		sc:RegisterFlagEffect(sc:GetOriginalCode(),RESET_EVENT+0x1ff0000,0,0)
		Duel.Destroy(g,REASON_EFFECT)
	else
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,204,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+0x1ff0000,0,0)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end

