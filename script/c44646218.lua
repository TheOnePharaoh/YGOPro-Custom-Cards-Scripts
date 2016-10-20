--Final Embrace
function c44646218.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c44646218.cost)
	e1:SetTarget(c44646218.target)
	e1:SetOperation(c44646218.activate)
	c:RegisterEffect(e1)
end
function c44646218.costfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(44646216) or c:IsCode(44646219) or c:IsCode(44646220) or c:IsCode(44646221) or c:IsCode(44646222) or c:IsCode(44646223) or c:IsCode(13739085) or c:IsCode(54759291) or c:IsCode(75963559) or c:IsCode(75963528) or c:IsCode(44646228)
end
function c44646218.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c44646218.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c44646218.costfilter,1,1,nil)
	e:SetLabel(g:GetFirst():GetLevel()*500)
	Duel.Release(g,REASON_COST)
end
function c44646218.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=e:GetLabel()~=0
		e:SetLabel(0)
		return res
	end
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,e:GetLabel())
	e:SetLabel(0)
end
function c44646218.activate(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Recover(1-tp,d,REASON_EFFECT)
	Duel.Recover(tp,d,REASON_EFFECT)
end
