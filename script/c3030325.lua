--女仆少女 妃雅辛丝
function c3030325.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20663556,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,3030325)
	e1:SetCost(c3030325.cost)
	e1:SetTarget(c3030325.target)
	e1:SetOperation(c3030325.operation)
	c:RegisterEffect(e1)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c3030325.syntg)
	e1:SetValue(1)
	e1:SetOperation(c3030325.synop)
	c:RegisterEffect(e1)
end
function c3030325.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==1 then 
		Duel.DiscardDeck(tp,1,REASON_COST)
		e:SetLabel(1)
	else
		local ac=0
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(85087012,2))
		if ct==2 then ac=Duel.AnnounceNumber(tp,1,2)
		else ac=Duel.AnnounceNumber(tp,1,2,3) end
		Duel.DiscardDeck(tp,ac,REASON_COST)
		e:SetLabel(ac)
	end
end
function c3030325.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3030325.filter,tp,LOCATION_GRAVE,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,0,tp,1)
end
function c3030325.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c3030325.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	local sg=Duel.GetDecktopGroup(1-tp,1)
	local tc=sg:GetFirst()
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c3030325.filter(c)
	return c:IsSetCard(0xaabb) and c:IsAbleToHand()
end
function c3030325.synfilter1(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c3030325.synfilter2(c,syncard,tuner,f)
	return c:IsSetCard(0xaabb) and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c3030325.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g=Duel.GetMatchingGroup(c3030325.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	if syncard:IsSetCard(0x3ad) then
		local exg=Duel.GetMatchingGroup(c3030325.synfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
		g:Merge(exg)
	end
	return g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
end
function c3030325.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g=Duel.GetMatchingGroup(c3030325.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	if syncard:IsSetCard(0x3ad) then
		local exg=Duel.GetMatchingGroup(c3030325.synfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
		g:Merge(exg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	Duel.SetSynchroMaterial(sg)
end