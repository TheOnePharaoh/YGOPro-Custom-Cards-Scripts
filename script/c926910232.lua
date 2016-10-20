--Astagraphy Eoh
function c926910232.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	local r1=Effect.CreateEffect(c)
	r1:SetType(EFFECT_TYPE_FIELD)
	r1:SetCode(EFFECT_SPSUMMON_PROC)
	r1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	r1:SetRange(LOCATION_HAND)
	r1:SetCondition(c926910232.runcon)
	r1:SetOperation(c926910232.runop)
	r1:SetValue(0x4f000000)
	c:RegisterEffect(r1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(926910232,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c926910232.descon)
	e1:SetTarget(c926910232.destg)
	e1:SetOperation(c926910232.desop)
	c:RegisterEffect(e1)
	--disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCondition(c926910232.actcon)
	e2:SetTarget(c926910232.acttg)
	c:RegisterEffect(e2)
end
function c926910232.matfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_TRAP)
end
function c926910232.matfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsSetCard(0xfef)
end
function c926910232.runfilter1(c)
	return c926910232.matfilter1(c) and Duel.IsExistingMatchingCard(c926910232.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,1,c)
end
function c926910232.runcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c926910232.runfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c926910232.runop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Group.CreateGroup()
	local g1=Duel.SelectMatchingCard(tp,c926910232.runfilter1,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
	g:Merge(g1)
	local g2=Duel.SelectMatchingCard(tp,c926910232.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
	g:Merge(g2)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+0x100000000)
end
function c926910232.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==0x4f000000
end
function c926910232.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c926910232.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local seq=0
	if tc:GetControler()==tp then
		seq=tc:GetSequence()
	else
		seq=4-tc:GetSequence()
	end
	local g=Group.CreateGroup()
	
	local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq)
	if tc then g:AddCard(tc) end
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq)
	if tc then g:AddCard(tc) end
	tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
	if tc then g:AddCard(tc) end
	tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
	if tc then g:AddCard(tc) end
	
	Duel.Destroy(g,REASON_EFFECT)
end
function c926910232.actcon(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c926910232.acttg(e,c)
	return bit.band(c:GetType(),0x20004)==0x20004
end

