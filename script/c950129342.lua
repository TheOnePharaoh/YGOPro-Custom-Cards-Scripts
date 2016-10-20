--Brotherhood of the Fire Fist - Ox
function c950129342.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	local r1=Effect.CreateEffect(c)
	r1:SetType(EFFECT_TYPE_FIELD)
	r1:SetCode(EFFECT_SPSUMMON_PROC)
	r1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	r1:SetRange(LOCATION_HAND)
	r1:SetCondition(c950129342.runcon)
	r1:SetOperation(c950129342.runop)
	r1:SetValue(0x4f000000)
	c:RegisterEffect(r1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c950129342.val)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c950129342.regop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(950129342,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,950129342+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c950129342.settg)
	e3:SetOperation(c950129342.setop)
	c:RegisterEffect(e3)
end
function c950129342.matfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x79) and c:IsType(TYPE_MONSTER)
end
function c950129342.matfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x7c)
end
function c950129342.runfilter1(c)
	return c950129342.matfilter1(c) and Duel.IsExistingMatchingCard(c950129342.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,c)
end
function c950129342.runcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c950129342.runfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c950129342.runop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Group.CreateGroup()
	local g1=Duel.SelectMatchingCard(tp,c950129342.runfilter1,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
	g:Merge(g1)
	local g2=Duel.SelectMatchingCard(tp,c950129342.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,10,g1:GetFirst(),c)
	g:Merge(g2)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+0x100000000)
end
function c950129342.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSummonType()==0x4f000000 then
		local ct=c:GetMaterialCount()-1
		c:RegisterFlagEffect(950129342,RESET_EVENT+0x1fe0000,0,0,ct*500)
	end
end
function c950129342.val(e,c)
	local ct=e:GetHandler():GetFlagEffectLabel(950129342)
	if not ct then return 0 end
	return ct
end
function c950129342.filter(c)
	return c:IsSetCard(0x7c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)
end
function c950129342.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
		and Duel.IsExistingMatchingCard(c950129342.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c950129342.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c950129342.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
