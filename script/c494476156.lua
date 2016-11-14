function c494476156.initial_effect(c)
  --lvchange
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(494476156,0))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c494476156.lvtg)
	e1:SetOperation(c494476156.lvop)
	c:RegisterEffect(e1)
  --spsummon
  local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c494476156.spcon)
	c:RegisterEffect(e2)
 end 
 
function c494476156.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x0600) and c:GetCode()~=494476156 and c:GetLevel()==8 or c:GetRank()==8
end
function c494476156.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c494476156.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c494476156.lvfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x0600)
end
function c494476156.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c494476156.lvfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
end
function c494476156.lvop(e,tp,eg,ep,ev,re,r,rp)
	local lv=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10,11,12)
	local g=Duel.GetMatchingGroup(c494476156.lvfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end