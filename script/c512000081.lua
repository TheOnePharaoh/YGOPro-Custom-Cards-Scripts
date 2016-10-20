--Thorn Princess
function c512000081.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c512000081.splimit)
	c:RegisterEffect(e1)
	--take control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511000268,0))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c512000081.target)
	e2:SetOperation(c512000081.operation)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511000268,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c512000081.dcost)
	e3:SetTarget(c512000081.dtg)
	e3:SetOperation(c512000081.dop)
	c:RegisterEffect(e3)
end
function c512000081.splimit(e,se,sp,st)
	return st==(SUMMON_TYPE_SPECIAL+511000267)
end
function c512000081.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c512000081.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and not Duel.GetControl(tc,tp) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c512000081.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c512000081.dfilter(c,code)
	return c:IsCode(code) and c:IsAbleToDeck() and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c512000081.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c512000081.dfilter,tp,LOCATION_GRAVE,0,1,nil,511000266) 
		and Duel.IsExistingMatchingCard(c512000081.dfilter,tp,LOCATION_GRAVE,0,1,nil,511000267)
		and Duel.IsExistingMatchingCard(c512000081.dfilter,tp,LOCATION_GRAVE,0,1,nil,511000268) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,0,0)
end
function c512000081.dop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c512000081.dfilter,tp,LOCATION_GRAVE,0,nil,511000266)
	local g2=Duel.GetMatchingGroup(c512000081.dfilter,tp,LOCATION_GRAVE,0,nil,511000267)
	local g3=Duel.GetMatchingGroup(c512000081.dfilter,tp,LOCATION_GRAVE,0,nil,511000268)
	if g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg3=g3:Select(tp,1,1,nil)
		sg1:Merge(sg3)
		Duel.HintSelection(sg1)
		Duel.SendtoDeck(sg1,nil,2,REASON_EFFECT)
	end
end
