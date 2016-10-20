--Odd-Eyes Reverse Dragon
function c112000009.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,16178681,aux.FilterBoolFunction(Card.IsType,TYPE_FUSION),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c112000009.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c112000009.spcon)
	e2:SetOperation(c112000009.spop)
	c:RegisterEffect(e2)
	--level change
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_LVCHANGE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c112000009.levcon)
	e3:SetOperation(c112000009.levop)
	c:RegisterEffect(e3)
end
function c112000009.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c112000009.spfilter(c,code)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_FUSION)
end
function c112000009.spfilter2(c,code)
	return c:IsAbleToGraveAsCost() and c:IsCode(16178681)
end
function c112000009.spcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_EXTRA)
	if ft<-1 then return false end
	local g1=Duel.GetMatchingGroup(c112000009.spfilter,tp,LOCATION_EXTRA,0,e:GetHandler())
	local g2=Duel.GetMatchingGroup(c112000009.spfilter2,tp,LOCATION_EXTRA,0,nil)
	if g1:GetCount()==0 or g2:GetCount()==0 then return false end
	if ft>0 then return true end
	local f1=g1:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
	local f2=g2:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
	if ft==-1 then return f1>0 and f2>0
	else return f1>0 or f2>0 end
end
function c112000009.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(27346636,2))
	local g1=Duel.SelectMatchingCard(tp,c112000009.spfilter,tp,LOCATION_EXTRA,0,1,1,e:GetHandler(),tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(27346636,3))
	local g2=Duel.SelectMatchingCard(tp,c112000009.spfilter2,tp,LOCATION_EXTRA,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(g1,nil,2,REASON_COST)
	Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
end
function c112000009.levcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c112000009.levop (e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end