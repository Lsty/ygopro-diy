--地底的鬼 伊吹萃香
function c41700009.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c41700009.cost)
	e1:SetTarget(c41700009.target)
	e1:SetOperation(c41700009.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetCondition(c41700009.spcon)
	c:RegisterEffect(e2)
end
function c41700009.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and c:IsSetCard(0x417) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c41700009.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,lv,e,tp)
end
function c41700009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c41700009.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c41700009.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
	Duel.SendtoGrave(sg,REASON_COST)
	e:SetLabel(sg:GetFirst():GetLevel())
end
function c41700009.spfilter(c,lv,e,tp)
	return c:GetLevel()==lv and c:IsRace(RACE_FIEND) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c41700009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c41700009.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	local slv=e:GetLabel()
	local ct=2
	local sg=Duel.GetMatchingGroup(c41700009.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,slv,e,tp)
	if sg:GetCount()==0 then return end
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		sg:RemoveCard(tc)
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		ft=ft-1
		ct=ct-1
	until ft<=0 or ct<=0 or sg:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(41700009,0))
	Duel.SpecialSummonComplete()
end
function c41700009.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_FIEND)
end
function c41700009.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c41700009.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end